#!/usr/bin/env python3.10
"""
Write a simple textual description of some Mac status items.
"""

import datetime
import re
import subprocess

def run(cmd):
    return subprocess.check_output(cmd).decode('utf8')

now = datetime.datetime.now()
print(f"{now:%-I:%M\n%b\u2009%-d}")

batt = run(["pmset", "-g", "batt"])
if m := re.search(r"\d+%", batt):
    level = m[0]
else:
    level = "??%"
if "discharging" in batt:
    arrow = "-"
elif "charging" in batt:
    arrow = "+"
else:
    arrow = ""

print(level + arrow)

vol = run(["osascript", "-e", "get volume settings"])
if m := re.search(r"^output volume:(\d+), .* muted:(\w+)", vol):
    level, muted = m.groups()
    if muted == 'true':
        level = "\u20e5"        # COMBINING REVERSE SOLIDUS OVERLAY
    print(f"\u24cb{level}")     # CIRCLED LATIN CAPITAL LETTER V

wifi = run(["/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport", "--getinfo"])
if m := re.search(r"lastTxRate: (\d+)", wifi):
    print(f"{m[1]}\u2933")

if m := re.search(r"(?m) SSID: (.+)$", wifi):
    ssid = m[1].strip()
    if len(ssid) > 5:
        ssid = ssid[:3] + ssid[-2:]
    print(ssid)
