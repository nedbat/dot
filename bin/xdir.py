"""
xdir: extended directory commands

Ned Batchelder, 12/2000
http://www.nedbatchelder.com

requires Python 2.0
"""

import os, os.path, re, string, sys

maxTrail = 400

def pathJoin(path, dir):
    """A slightly more intelligent path join."""
    if path == os.curdir:
        return dir
    else:
        return os.path.join(path, dir)

def glue(l):
    """Glue the elements of a list together: [[1,2], [3,4]] --> [1,2,3,4]"""
    return reduce(lambda a,b: a+b, l)

def multiSplit(s, seps):
    """Separate a string by a list of separators"""
    ret = [s]
    for sep in seps:
        ret = glue(map((lambda s: s.split(sep)), ret))
    return ret

def findDir(dir, prefixes):
    """
    Find directories that match a list of prefixes. Various punctuations on the
    prefixes mean various things:
    
        pre     match a direct directory beginning with "pre" (case-insensitive)
        pre.    match a direct directory named "pre" (case-insensitive)
        .pre    match a descendant directory deep beginning with "pre"
        .       go up a directory
        ..      go up a directory
        @file   match the current directory if it contains a file named "file"
        .@file  match a descendant directory if it contains a file named "file"
        ,abc    treat as three prefixes: a b c

    Returns a list of file paths that match.
    """
    
    #End the recursion: if the list of prefixes is empty, the current directory
    #is it.
    if len(prefixes) == 0:
        return [dir]

    prefix = prefixes[0].lower()
    
    # If the first prefix is an empty string, ignore it. This lets us use
    # "x \" to get to the root, and ignore multiple slashes: "x a//b" is the
    # same as "x a/b".
    if len(prefix) == 0:
        return findDir(dir, prefixes[1:])

    # If the first prefix starts with comma, then it is really a list of
    # single-character prefixes.  Adjust the prefixes list before intepreting.

    if prefix[0] == ',':
        prefixes = list(prefix[1:]) + prefixes[1:]
        prefix = prefixes[0]

    isDeep = 0
    isExact = 0
    isFile = 0
    isWild = 0
    
    if prefix == "." or prefix == os.pardir:
        # . or .. means .. !
        return findDir(pathJoin(dir, os.pardir), prefixes[1:])
    elif prefix[0] == ".":
        # .foo means foo anywhere below here
        prefix = prefix[1:]
        isDeep = 1

    if os.name == 'nt':
        if len(prefix) == 2 and prefix[1] == ':':
            return findDir(prefix + '\\', prefixes[1:])
            
    if prefix[-1] == ".":
        # foo. means the directory must be named foo, not just start with foo.
        prefix = prefix[:-1]
        isExact = 1

    if prefix[0] == "@":
        # @foo means the directory contains a file named foo.
        prefix = prefix[1:]
        isFile = 1

    if prefix.find(",") >= 0:
        isWild = 1
        
    try:
        files = os.listdir(dir)
    except KeyboardInterrupt:
        raise KeyboardInterrupt
    except:
        # something went wrong, so we can't go here.
        return []
        
    if ".xdir_ignore" in files:
        # If the directory contains a .xdir_ignore file, then don't traverse
        # through it.
        return []

    dirs = [ f for f in files if os.path.isdir(pathJoin(dir, f)) ]
    
    if isFile:
        if prefix in files:
            okdirs = [ os.curdir ]
        else:
            okdirs = []
    else:
        if isWild:
            import re
            if isExact:
                pat = re.compile('[^ ]* '.join(prefix.split(',')) + '[^ ]*$')
            else:
                pat = re.compile('[^ ]* '.join(prefix.split(',')))
            we_like_it = lambda d, re=pat: re.match(d)
        elif isExact:
            we_like_it = lambda d, p = prefix: d == p
        else:
            we_like_it = lambda d, p = prefix: d.startswith(p)
    
        okdirs = [ d for d in dirs if we_like_it(d.lower()) ]

    ret = []
    for d in okdirs:
        ret += findDir(pathJoin(dir, d), prefixes[1:])

    if isDeep:
        for d in dirs:
            ret += findDir(pathJoin(dir, d), prefixes)

    return ret

#
# The interface to the calling operating system.
#

if os.name == 'nt':
    # To use this on Windows, create a .cmd file like this:
    #
    #   @echo off
    #   xdir.py %* >%TEMP%\__xdir.cmd
    #   call %TEMP%\__xdir.cmd    
    #
    # Then use doskey to make aliases like this:
    #
    #   doskey u=xdir.cmd cd .. $*
    #   doskey uu=xdir.cmd cd .. .. $*
    #   doskey uuu=xdir.cmd cd .. .. .. $*
    #   
    #   doskey x=xdir.cmd cd $*
    #   doskey ux=xdir.cmd cd .. $*
    #   doskey uux=xdir.cmd cd .. .. $*
    #   
    #   doskey xb=xdir.cmd back $*
    #   doskey xp=xdir.cmd push $*
    #   doskey xq=xdir.cmd pop $*
    #   doskey xl=xdir.cmd roll $*
    #   doskey xs=xdir.cmd showstack $*
    
    class TooLong:
        """An exception for command too long."""
        pass

    maxCmdLen = 2000
    seps = '/\\'
    
    def quoteForDos(str):
        """Quote special characters (with carets, who knew?)"""
        for c in "^&|<>":
            str = str.replace(c, '^'+c);
        return str;

    def readList(name):
        """Read the stack of directories from the environment, and return it as a list."""
        try:
            return os.environ["XDIR_"+name.upper()].split(";")
        except KeyError:
            return []
    
    def writeList(name, l):
        """Write a stack of directories."""
        while 1:
            try:
                writeSetEnviron("XDIR_"+name.upper(), ';'.join(l))
                break
            except TooLong:
                # If we couldn't fit the whole list, trim at the end.
                l = l[:-1]

    def writeCd(dir):
        """Write a change directory command."""
        # Changing disks requires two steps.
        if len(dir) > 1 and dir[1] == ':':
            print dir[:2]
            dir = dir[2:]
        print "cd", quoteForDos(dir)
    
    def writeMsg(msg):
        """Write a message to the user."""
        print "echo", quoteForDos(msg)
    
    def writeSetEnviron(name, value):
        """Write a set environment command."""
        cmd = "set " + name + "=" + quoteForDos(value)
        if len(cmd) > maxCmdLen:
            raise TooLong
        print cmd

    def writeSetPrompt(prompt):
        """Write a set prompt command."""
        writeSetEnviron('PROMPT', prompt)
else:
    raise "There's no code for this platform yet!"

# defined lists

def readStack():            return readList("stack")
def writeStack(stack):      writeList("stack", stack)
def readTrail():            return readList("trail")
def writeTrail(trail):      writeList("trail", trail)

def squishedDir(d):
    """Create a directory string for the prompt."""
    
    if len(d) < 40:
        return d
    dlist = d.split(os.sep)
    newd = []
    for dpart in dlist:
        if len(dpart) > 3:
            dpart = dpart[:3]
        newd += [dpart]
        
    return '['+string.join(newd, os.sep)+']'        
    
# Any change to the directory leaves breadcrumbs

def changeDir(d):
    trail = readTrail()
    trail = ([os.getcwd()] + trail)[:maxTrail]
    writeTrail(trail)
    changeDirPlain(d)

def changeDirPlain(d):
    writeCd(d)
    writeSetPrompt(squishedDir(os.path.abspath(d)) + '$G$S')
    
#
# The primary operations
#

def doBack(args):
    if len(args) == 0:
        num = 1
    else:
        num = string.atoi(args[0])
    trail = readTrail()
    if len(trail) == 0:
        writeMsg("No history!")
    else:
        changeDirPlain(trail[num-1])
        writeTrail(trail[num:])

def doCd(prefixes):
    # If no prefixes, then just change dir to current directory.
    if len(prefixes) == 0:
        changeDir(os.curdir)
        return 1
    
    # If the first prefix begins with \ , then start at the root.
    #writeMsg("Prefixes: " + str(prefixes))
    for sep in seps:
        if prefixes[0].startswith(sep):
            prefixes[0] = prefixes[0][1:]
            startdir = os.sep
            break
    else:
        startdir = os.curdir

    # Split the prefixes at path separators, so we can use standard syntax
    prefixes = glue([ multiSplit(p, seps) for p in prefixes ])
    
    # The last prefix may really be a numeric selector (for choosing among a
    # number of matches).
    numChoice = 0
    lastPrefix = prefixes[-1]
    match = re.match(r"\.-?[0-9]+", lastPrefix)
    if match:
        if match.group() == lastPrefix:
            numChoice = int(lastPrefix[1:])
            prefixes = prefixes[:-1]

    # Find the list of files that match.
    dirs = findDir(startdir, prefixes)

    # What we do next depends on how many files matched, and whether there was
    # a numerical choice.
    if len(dirs) == 0:
        # no matches, write a simple message
        writeMsg("Nothing matched!")
        return 0
    elif len(dirs) == 1:
        # one directory matched, go there
        changeDir(dirs[0])
        return 1
    elif 0 < numChoice <= len(dirs):
        # many directories, but we specified a numeric choice
        changeDir(dirs[numChoice-1])
        return 1
    elif -len(dirs) <= numChoice < 0:
        # A negative number choice:
        changeDir(dirs[numChoice])
        return 1
    
    # ambiguous: just write all the choices.
    for d in dirs:
        writeMsg(d)
    return 0

def doClear(prefixes):
    writeTrail([])
    writeStack([])
    doCd(prefixes)
    
def doHistory():
    for d in readTrail():
        writeMsg(d)
        
def doPop():
    stack = readStack()
    if len(stack) == 0:
        writeMsg("Stack empty!")
    else:
        changeDir(stack[0])
        writeStack(stack[1:])

def doPush(prefixes):
    stack = readStack()
    stack = [os.getcwd()] + stack
    writeStack(stack)
    ok = doCd(prefixes)
    if ok == 0:
        writeStack(stack[1:])

def doRoll(args):
    if len(args) == 0:
        num = 1
    else:
        num = string.atoi(args[0])
    stack = readStack()
    stack = [os.getcwd()] + stack
    num %= len(stack)
    stack = stack[num:] + stack[:num]
    changeDir(stack[0])
    del stack[0]
    writeStack(stack)

def doShowStack():
    for d in readStack():
        writeMsg(d)

def main():
    cmd = sys.argv[1]

    if cmd == "back":
        doBack(sys.argv[2:])
    elif cmd == "cd":
        doCd(sys.argv[2:])
    elif cmd == "clear":
        doClear(sys.argv[2:])
    elif cmd == "history":
        doHistory()
    elif cmd == "pop":
        doPop()
    elif cmd == "push":
        doPush(sys.argv[2:])
    elif cmd == "roll":
        doRoll(sys.argv[2:])
    elif cmd == "showstack":
        doShowStack()
    else:
        writeMsg("Don't understand command '"+cmd+"'")
        writeMsg("Choices are: back cd clear history pop push roll showstack")

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        writeMsg("--interrupted--")


# History:
# 12/2000:      first version
# 10/24/2001:   Added trail, back, and clear.
# 11/16/2001:   Added commas as space-separated wildcard.
# 12/26/2001:   Understands disk letters on win32.
# 12/27/2001:   Added setting the prompt, squishing directories.
# 4/18/2002:    Added negative number choice.
# 10/16/2002:   More flexibility with separators.
# 3/25/2003:    Allow "clear" to specify a new dir to cd to.
# 2/14/2010:    DOS works better if you use $G$S instead of "> " in prompts.
