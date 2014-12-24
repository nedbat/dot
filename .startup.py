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
