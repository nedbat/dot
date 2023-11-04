#!/usr/bin/env python3
"""Scrub needless files to save space"""

import os
from pathlib import Path
import shutil
import subprocess

total_saved = 0

def command_output(cmd, harden=False):
    if harden:
        cmd = f"{cmd} 2>/dev/null || true"
    try:
        return subprocess.check_output(cmd, shell=True).decode("utf-8")
    except Exception as exc:
        print(exc)

def path_for(dirname):
    return Path(dirname).expanduser()

def get_size(dirpath):
    if dirpath.exists():
        # -H: Symbolic links on the command line are followed, symbolic links in file hierarchies are not followed.
        # -s: Display an entry for each specified file.
        # -k:  Display block counts in 1024-byte (1 kiB) blocks.
        output = command_output(f"du -Hsk {dirpath}", harden=True)
        size = int(output.split("\t")[0])
    else:
        size = 0
    return size * 1024

def clean(dirname, cmd=None):
    print(f"---- {dirname}: {cmd.__doc__.strip()}")
    dirpath = path_for(dirname)
    if not dirpath.exists():
        print("Doesn't exist")
        return
    before = get_size(dirpath)
    print(f"before: {before:15,d}")
    output = cmd(str(dirpath)) or ""
    if output.strip():
        print(output.rstrip())
    after = get_size(dirpath)
    saved = before - after
    print(f"after:  {after:15,d}")
    print(f"saved:  {saved:15,d}")
    global total_saved
    total_saved += saved


def rmrf(dirname):
    """Remove completely"""
    shutil.rmtree(dirname, ignore_errors=True)

def cmd(template, doc=None, harden=False):
    def doit(dirname):
        print(command_output(template.format(dirname=dirname), harden=harden))
    doit.__doc__ = doc or template
    return doit

def make(targets):
    def doit(dirname):
        print(command_output(f"make --quiet --directory '{dirname}' {targets}"))
    doit.__doc__ = f"make {targets}"
    return doit

rm_pyc = cmd(r"find {dirname} -regex '.*\.py[cow]' -delete", "Delete .pyc etc files")
rm_tox = cmd(r"find {dirname} -name '.tox' -exec rm -rf {{}} \; -prune", "Delete .tox directories", harden=True)

clean(command_output("brew --cache").strip(), rmrf)
clean("/usr/local/pyenv/pyenv/cache", rmrf)
clean("~/Documents/Zoom", rmrf)
clean("~/Library/Caches/com.spotify.client", rmrf)
clean("~/Library/Caches/pip", rmrf)
clean("~/Library/Caches/pipenv", rmrf)
clean("~/Library/Caches/pip-tools", rmrf)
clean("~/Library/Caches/yarn", rmrf)
clean("~/.dropbox/Crashpad/completed", rmrf)
clean("~", rm_tox)
clean("/src", rm_tox)
clean("/usr/local/virtualenvs", rm_pyc)
clean("/usr/local/pyenv", rm_pyc)
clean("/usr/local/pypy", rm_pyc)
pycdir = os.environ.get("PYTHONPYCACHEPREFIX", "")
if pycdir:
    clean(pycdir, rmrf)
clean("~/log/irc", cmd("afsctool -cvv -9 {dirname}"))
for d in [
    "coverage/trunk",
    "scriv",
    "coverage/django_coverage_plugin",
    "cog",
    "web/stellated",
]:
    clean(f"~/{d}", make("sterile"))

print(f"----\nTOTAL saved:  {total_saved:15,d}")
