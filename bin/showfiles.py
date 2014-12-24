"""
Simple file lister to show me what I want to see.
Ned Batchelder, 12/14/2001
http://www.nedbatchelder.com
"""

# Things that aren't right here:
#   - I have a copy of the standard glob module (I forget why!)
#   - The recursive mode is dumb: it works just as if you had typed
#       "showfiles * *\* *\*\* *\*\*\* ... on the command line.
#   - -rx gets confused by paths like foo.bar\something, where it thinks
#       the extension is ".bar\something".

import getopt, os, string, sys, time
from stat import *

### Bogus: this is a tweaked copy of the standard glob module.
import fnmatch, re

def glob(pathname):
    """Return a list of paths matching a pathname pattern.

    The pattern may contain simple shell-style wildcards a la fnmatch.
    """
    if not has_magic(pathname):
        if os.path.exists(pathname):
            return [pathname]
        else:
            return []
    dirname, basename = os.path.split(pathname)
    if not dirname:
        return glob1(os.curdir, basename)
    elif has_magic(dirname):
        list = glob(dirname)
    else:
        list = [dirname]
    if not has_magic(basename):
        result = []
        for dirname in list:
            if basename or os.path.isdir(dirname):
                name = os.path.join(dirname, basename)
                if os.path.exists(name):
                    result.append(name)
    else:
        result = []
        for dirname in list:
            sublist = glob1(dirname, basename)
            for name in sublist:
                result.append(os.path.join(dirname, name))
    return result

def glob1(dirname, pattern):
    if not dirname: dirname = os.curdir
    try:
        names = os.listdir(dirname)
    except os.error:
        return []
    return fnmatch.filter(names,pattern)


magic_check = re.compile('[*?[]')

def has_magic(s):
    return magic_check.search(s) is not None
### end Bogus

if os.name == 'nt':
    import win32file
    def fileAttr(f, dummy):
        ret = ''
        attr = win32file.GetFileAttributes(f)
        attrs = [
            (win32file.FILE_ATTRIBUTE_READONLY, 'r'),
            (win32file.FILE_ATTRIBUTE_HIDDEN,   'h'),
            (win32file.FILE_ATTRIBUTE_SYSTEM,   's')
            ]
        for bit, char in attrs:
            if attr & bit:
                ret += char
            else:
                ret += ' '
        return ret

else:
    def fileAttr(f, s):
        return '   '

def formatTime(secs):
    try:
        tup = time.localtime(secs)
    except:
        return '--/--/-- --:--:-- '
    ret = time.strftime('%m/%d/%y %I:%M:%S', tup)
    if tup[3] >= 12:
        if tup[3] == 12 and tup[4] == 0:
            ret += 'n'  # noon
        else:
            ret += 'p'  # pm
    else:
        if tup[3] == 0 and tup[4] == 0:
            ret += 'm'  # midnight
        else:
            ret += 'a'  # am
    return ret

def formatSize(size):
    """Format a size for display"""
    # There ought to be an easier way to do this.
    sl = [c for c in str(size)]
    for i in range(len(sl)-3, 0, -3):
        sl[i:i] = [',']
    return string.join(sl, '')

lineformat = '%18s %3s %11s %s'
totalformat = '= %s bytes, %s files'

class FileEntry:
    def __init__(self, filespec):
        """
        Create a FileEntry from either a string, or a pair of strings
        (directory, file).
        """
        if type(filespec) == type(()):
            self.dir, self.name = filespec
            self.path = os.path.join(*filespec)
        else:
            self.dir = '.'
            self.name = filespec
            self.path = filespec
            
        stat = os.stat(self.path)
        self.size = stat[ST_SIZE]
        self.mod = stat[ST_MTIME]
        self.isDir = S_ISDIR(stat[ST_MODE])
        self.attr = fileAttr(self.path, stat)
        
    def longForm(self):
        mod = formatTime(self.mod)
        size = formatSize(self.size)
        if self.isDir:
            size = '/'
        return lineformat % (mod, self.attr, size, self.name)

    def shortForm(self):
        return self.name

    def lcaseName(self):
        return string.lower(self.name)

    def extension(self):
        """Return the extension of an entry"""
        if self.isDir:
            return '/'
        elif self.name[1:].find('.') != -1:
            return self.lcaseName().split('.')[-1]
        else:
            return " "

    
def nameCompare(e1, e2):
    """Case=insensitive compare"""
    if e1.isDir and not e2.isDir:
        return -1
    if e2.isDir and not e1.isDir:
        return 1
    
    s1 = e1.lcaseName()
    s2 = e2.lcaseName()
    if s1 < s2:
        return -1
    elif s1 > s2:
        return 1
    else:
        return 0

def sizeCompare(e1, e2):
    """Compare by size"""
    if e1.size < e2.size:
        return -1
    elif e1.size > e2.size:
        return 1
    else:
        return 0
    
def dateCompare(e1, e2):
    """Compare by date"""
    if e1.mod < e2.mod:
        return -1
    elif e1.mod > e2.mod:
        return 1
    else:
        return 0

def extCompare(e1, e2):
    """Compare by extension"""
    if e1.isDir and not e2.isDir:
        return -1
    if e2.isDir and not e1.isDir:
        return 1
    
    x1 = e1.extension()
    x2 = e2.extension()
    if x1 < x2:
        return -1
    elif x1 > x2:
        return 1
    else:
        return nameCompare(e1, e2)

def starify(s):
    return [ i*'*/'+s for i in range(10) ]
        
def glue(l):
    """Glue the elements of a list together: [[1,2], [3,4]] --> [1,2,3,4]"""
    return reduce(lambda a,b: a+b, l)

def main(args):

    def usage():
        print '-od -os -ox -d -s -x -r -b'
        sys.exit()
        
    try:
        opts, args = getopt.getopt(args, "bo:dsxr")
    except getopt.GetoptError:
        # print help information and exit:
        usage()

    # Collect the options
    
    sortfn = nameCompare
    deep = 0
    brief = 0
    
    for o, a in opts:
        if o == '-o':
            if a == 'd':
                sortfn = dateCompare
            elif a == 's':
                sortfn = sizeCompare
            elif a == 'x':
                sortfn = extCompare
            else:
                usage()
        elif o == '-d':
            sortfn = dateCompare
        elif o == '-s':
            sortfn = sizeCompare
        elif o == '-x':
            sortfn = extCompare
        elif o == '-r':
            deep = 1
        elif o == '-b':
            brief = 1
        else:
            usage()

    # Collect the files
    
    files = []

    specs = args or ['*']
    
    if deep:
        specs = glue([starify(s) for s in specs])
    for a in specs:
        bFile = os.access(a, os.F_OK)
        if bFile:
            stat = os.stat(a)
            if S_ISDIR(stat[ST_MODE]):
                newFiles = os.listdir(a)
                if a != '.':
                    newFiles = map((lambda f,d=a: (d, f)), newFiles)
                files += newFiles
            else:
                files += [a]
        else:
            files += glob(a)
    entries = [ FileEntry(f) for f in files ]

    # Sort the entries
    
    entries.sort(sortfn)

    # Print the entries
    
    totsize = 0
    nfiles = 0
    for e in entries:
        totsize += e.size
        nfiles += 1
        if brief:
            print e.shortForm()
        else:
            print e.longForm()
        
    if not brief:
        print totalformat % (formatSize(totsize), nfiles)

if __name__ == '__main__':
    main(sys.argv[1:])
