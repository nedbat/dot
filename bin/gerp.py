#!/usr/bin/env python3.8
"""
- gerp *tree* pattern modifiers

- *tree*:
    - a .treerc file
    - a filename, look upwards for .treerc

- .treerc:

    ignore = .hg .svn *.pyc *.pyo *.pyd *.jpg *.png *.gif
    [subset]
    ignore = patterns
    root = roots

- pattern: /pat/
    matches against just the filename, or the whole path.
    Use leading */ if you need to match against the whole path.

- modifiers:
    =subset     (NOT IMPLEMENTED)
    .po     only search these extensions
    -.po    ignore these extensions
"""

import fnmatch, os, os.path, re, subprocess, sys
import shlex
import configparser
from io import StringIO

INI = ".treerc"
HOME_INI = "~/.treerc_default"

ROOT_MARKERS = [".git", ".hg"]

IGNORE = """
    *.o *.bak
    *.so *.dll
    *.pyc *.pyo *.pyd
    *.png *.jpg *.jpeg *.gif *.ico *.bmp
    .svn .git .hg
    venv .tox
    *.ttf *.eot
    *.pdf
    *.zip *.tar *.gz
    """

DEFAULTS = {
    'root': '.',
    }

class GerpException(Exception):
    pass

SENSITIVE, INSENSITIVE, SMART = range(3)

class Gerp(object):
    def __init__(self):
        # arguments
        self.tree = None
        self.pattern = None
        self.section = "default"
        self.adhoc_ignore = []
        self.adhoc_include = []
        self.word = False
        self.sensitivity = SMART
        self.one = False

        self.ini = None
        self.ini_text = None
        self.ini_dir = None

        self.roots = []
        self.config = None

        self.use_rg = True  # TODO: make this right.

    def from_args(self, args):
        if len(args) < 1:
            raise GerpException("Need a tree spec")
        self.tree = args[0]

        for arg in args[1:]:
            if arg[0] == "/":
                self.pattern = arg[1:]
                if self.pattern.endswith("/"):
                    self.pattern = self.pattern[:-1]
            elif arg[0:2] == "-.":
                self.adhoc_ignore.append("*"+arg[1:])
            elif arg[0:3] == "-*.":
                self.adhoc_ignore.append(arg[1:])
            elif arg == "-w":
                self.word = True
            elif arg == "-i":
                self.sensitivity = INSENSITIVE
            elif arg == "-c":
                self.sensitivity = SENSITIVE
            elif arg == "-e":
                self.sensitivity = SENSITIVE
                self.word = True
            elif arg == "-1":
                self.one = True
            elif arg == "-rg":
                self.use_rg = True
            elif arg[0] == ".":
                self.adhoc_include.append("*"+arg)
            elif arg[0:2] == "*.":
                self.adhoc_include.append(arg)

    def find_ini(self):
        folder = os.path.abspath(self.tree)
        if not os.path.isdir(folder):
            folder = os.path.split(folder)[0]
        folder0 = folder
        repo_folder = None
        while folder:
            # Does this folder have .treerc?
            try_ini = os.path.join(folder, INI)
            if os.path.exists(try_ini):
                self.ini = try_ini
                self.ini_dir = os.path.split(self.ini)[0] + os.sep
                break
            # Is this folder the root of a repo?
            for root_marker in ROOT_MARKERS:
                try_root = os.path.join(folder, root_marker)
                if os.path.exists(try_root) and repo_folder is None:
                    repo_folder = folder
                    break
            next_folder = os.path.split(folder)[0]
            if next_folder == folder:
                break
            folder = next_folder
        if self.ini is None:
            # Didn't find a .treerc, use the self.tree folder as the root.
            self.ini_dir = repo_folder or folder0
            home_default_ini = os.path.expanduser(HOME_INI)
            if os.path.exists(home_default_ini):
                self.ini = home_default_ini
            else:
                self.ini_text = "[default]\nroot = %s\n" % folder0

    def run(self):
        # Find the tree.ini file.
        self.find_ini()

        # Parse the ini file.
        self.config = configparser.RawConfigParser(DEFAULTS)
        if self.ini:
            self.config.read(self.ini)
        if self.ini_text:
            self.config.read_file(StringIO(self.ini_text))

        cur_dir = os.getcwd()
        for r in self.config.get(self.section, "root").split('\n'):
            if not r:
                continue
            self.roots.append(os.path.normpath(os.path.join(self.ini_dir, r)))

        if self.use_rg:
            self.run_rg()
        else:
            self.run_native()

    def run_rg(self):
        rg_words = [
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--hidden",
        ]
        if not self.ini:
            rg_words.append("--no-ignore")

        for ignore in self.ignores():
            rg_words.extend(["--glob", "!"+ignore])

        for include in self.adhoc_include:
            rg_words.extend(["--glob", include])

        if self.insensitive():
            rg_words.append("--ignore-case")

        if self.word:
            rg_words.append("--word-regexp")

        pattern = self.pattern
        if pattern.startswith("-"):
            pattern = "[-]" + pattern[1:]
        rg_words.extend(["--regexp", pattern])

        if self.one:
            starts = [self.tree]
        else:
            starts = self.roots

        for start in starts:
            cmd = rg_words + [start]
            p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
            for line in iter(p.stdout.readline, b''):
                print(line.rstrip().decode("utf-8"))

    def ignores(self):
        ignores = set(IGNORE.split())
        if self.config.has_option(self.section, "ignore"):
            ignores.update(self.config.get(self.section, "ignore").split())
        ignores.update(self.adhoc_ignore)
        return ignores

    def insensitive(self):
        insensitive = (self.sensitivity == INSENSITIVE)
        if (self.sensitivity == SMART) and not re.search(r"[A-Z]", self.pattern):
            # Smart-casing: if the pattern has no upper-case, then be case-insensitive
            insensitive = True
        return insensitive

    def run_native(self):
        # Build the ignore regex.
        self.ignore_re = self.pats_to_regex(self.ignores())

        # Build the include regex.
        if self.adhoc_include:
            self.include_re = self.pats_to_regex(self.adhoc_include)
        else:
            self.include_re = None

        # Get the pattern ready.
        if not self.pattern:
            raise GerpException("No pattern to find!")
        if self.word:
            # Wordiness: \b means, the empty string between a word character
            # (\w) and a non-word character (\W). So if the pattern begins with
            # a non-word character, don't add it at the beginning. Same for
            # the end.
            if re.search(r"^\w", self.pattern):
                self.pattern = r"\b" + self.pattern
            if re.search(r"\w$", self.pattern):
                self.pattern += r"\b"
        if self.insensitive():
            self.pattern = r"(?i)" + self.pattern

        try:
            pat = re.compile(self.pattern)
        except Exception as e:
            raise GerpException("Bad pattern: %s" % e)

        if self.one:
            files = [self.tree]
        else:
            files = self.files()

        # Grep through the files!
        for f in files:
            try:
                fopened = open(f)
            except:
                continue
            with fopened:
                ftrimmed = None
                for lineno, line in enumerate(fopened, start=1):
                    # Crazy-long lines mean we're looking at minified text, skip it.
                    if lineno < 20 and len(line) > 500 and not line.startswith((' ', '\t')):
                        break
                    if pat.search(line):
                        if not ftrimmed:
                            ftrimmed = f
                            #if ftrimmed.startswith(cur_dir):
                            #    ftrimmed = ftrimmed.replace(cur_dir, "")
                        print("%s:%d:%s" % (ftrimmed, lineno, line[:-1]))

    def file_match(self, pattern, dirpath, filename):
        """Check if filename in dirpath matches pattern."""
        if pattern.match(filename):
            return True
        if pattern.match(os.path.join(dirpath, filename)):
            return True
        return False

    def files(self):
        # Walk the trees specified by roots, skipping stuff mentioned in ignores.
        for root in self.roots:
            for dirpath, dirnames, filenames in os.walk(root, topdown=True):
                for f in filenames:
                    if self.include_re:
                        include = self.file_match(self.include_re, dirpath, f)
                    else:
                        include = not self.file_match(self.ignore_re, dirpath, f)
                    if include:
                        yield os.path.join(dirpath, f)
                baddirs = []
                for i, d in enumerate(dirnames):
                    if self.file_match(self.ignore_re, dirpath, d):
                        baddirs.append(i)
                baddirs.reverse()
                for i in baddirs:
                    del dirnames[i]

    def pats_to_regex(self, pats):
        """Turn a list of fnmatch-style patterns into a regex."""
        regex = "(" + ")|(".join(fnmatch.translate(pat) for pat in pats) + ")"
        return re.compile(regex)

def main(args):
    try:
        gerp = Gerp()
        gerp.from_args(args)
        gerp.run()
    except GerpException as ge:
        print(str(ge), file=sys.stderr)
    except KeyboardInterrupt:
        print("** Stopped", file=sys.stderr)

if __name__ == '__main__':
    main(sys.argv[1:])
