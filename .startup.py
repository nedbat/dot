# Ned's startup.py file, loaded into interactive python prompts.

print("(.startup.py)")

try:
    from autoimp import *
    print("(from autoimp import *)")
except:
    import datetime, itertools, math, os, pprint, re, sys, time
    print("(imported datetime, itertools, math, os, pprint, re, sys, time)")

def dirx(thing, regex):
    return [ n for n in dir(thing) if re.search(regex, n) ]

pp = pprint.pprint

import atexit
import os
import readline
import rlcompleter

historyPath = os.path.expanduser("~/.pyhistory")

def save_history(historyPath=historyPath):
    import readline
    readline.write_history_file(historyPath)

if os.path.exists(historyPath):
    readline.read_history_file(historyPath)

atexit.register(save_history)
del atexit, readline, rlcompleter, save_history, historyPath
