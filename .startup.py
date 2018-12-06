# Ned's startup.py file, loaded into interactive python prompts.
# Has to work on both 2.x and 3.x

print("(.startup.py)")

try:
    from autoimp import *
    print("(from autoimp import *)")
except:
    import collections, datetime, itertools, math, os, pprint, re, sys, time
    print("(imported collections, datetime, itertools, math, os, pprint, re, sys, time)")

def dirx(thing, regex):
    return [ n for n in dir(thing) if re.search(regex, n) ]

pp = pprint.pprint

# A function for pasting code into the repl.
# From: https://mail.python.org/pipermail/python-list/2016-September/714384.html
def paste():
    exec(sys.stdin.read(), globals())

# Readline and history support
def hook_up_history():
    try:
        # Not sure why this module is missing in some places, but deal with it.
        import readline
    except ImportError:
        print("No readline, use ^H")
    else:
        import atexit
        import os
        import rlcompleter

        historyPath = os.path.expanduser("~/.pyhistory{0}".format(sys.version_info[0]))

        def save_history(historyPath=historyPath):
            import readline
            readline.write_history_file(historyPath)

        if os.path.exists(historyPath):
            readline.read_history_file(historyPath)

        atexit.register(save_history)

# Don't do history stuff if we are IPython, it has its own thing.
is_ipython = 'In' in globals()
if not is_ipython:
    hook_up_history()

# Get rid of globals we don't want.
del is_ipython, hook_up_history
