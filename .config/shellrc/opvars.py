# Do the data munging for the opvars and unopvars aliases in opvars.sh

import json
import sys

op = sys.argv[1]

try:
    jdata = json.load(sys.stdin)
except:
    # For when 1Password isn't logged in, or can't find the values.
    pass
else:
    assigns = jdata["value"]

    args = []
    for line in assigns.splitlines():
        line = line.strip()
        if line.startswith("#"):
            continue
        if not line:
            continue

        if op == "export":
            args.append(line)
        elif op == "unset":
            args.append(line.partition('=')[0])

    if args:
        print(op, " ".join(args))
