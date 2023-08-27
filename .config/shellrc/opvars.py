# Do the data munging for the opvars and unopvars aliases in opvars.sh

import json
import os
import shlex
import sys

OPVARS_VAR = "_OPVARS"
PROMPT_VAR = f"{OPVARS_VAR}_PROMPT"

def read_values():
    try:
        jdata = json.load(sys.stdin)
    except:
        # For when 1Password isn't logged in, or can't find the values.
        pass
    else:
        return jdata["value"]

def cmd(line):
    print(line, end="; ")

def end_cmd():
    print(":")

def main():
    op = sys.argv[1]
    opvars = set(os.environ.get(OPVARS_VAR, "").split())

    if op == "export":
        oldvars = set(opvars)
        newvars = []
        args = []
        assigns = read_values()
        if not assigns:
            return
        for line in assigns.splitlines():
            line = line.strip()
            if line.startswith("#"):
                continue
            if not line:
                continue

            args.append(line)
            varname = line.partition('=')[0]
            opvars.add(varname)
            newvars.append(varname)
            if varname in oldvars:
                oldvars.remove(varname)

        if args:
            cmd(f"export {' '.join(map(shlex.quote, args))}")
            cmd(f"export {OPVARS_VAR}='{' '.join(opvars)}'")
            stars = "*" * len(opvars)
            cmd(f"export {PROMPT_VAR}='{stars} '")
            cmd(f"echo set these: {' '.join(newvars)}")
            if oldvars:
                cmd(f"echo still set: {' '.join(oldvars)}")

    elif op == "unset":
        if opvars:
            cmd(f"unset {' '.join(opvars)}")
            cmd(f"echo removed: {' '.join(sorted(opvars))}")
        else:
            cmd(f"echo Nothing set")
        cmd(f"export {PROMPT_VAR}=''")
        cmd(f"unset {OPVARS_VAR}")

    end_cmd()

main()
