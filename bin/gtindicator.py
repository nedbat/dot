#!/usr/bin/env python3.6
"""
Designed for use with GeekTool


"""

import datetime
import re
import subprocess

def block_eighths(eighths):
    """Return the Unicode string for a block of so many eighths."""
    assert 0 <= eighths <= 8
    if eighths == 0:
        return "\u2003"
    else:
        return chr(0x2590 - eighths)

def gauge(percent):
    """Return a two-char string drawing a 16-part gauge."""
    slices = round(percent / (100 / 16))
    b1 = block_eighths(min(slices, 8))
    b2 = block_eighths(max(slices - 8, 0))
    return b1 + b2

def run(cmd):
    return subprocess.check_output(cmd).decode('utf8')

def supered(s):
    normal = "abcdefghijklmnopqrstuvwxyz0123456789"
    superscripts = "ᵃᵇᶜᵈᵉᶠᵍʰⁱʲᵏˡᵐⁿᵒᵖᵠʳˢᵗᵘᵛʷˣʸᶻ⁰¹²³⁴⁵⁶⁷⁸⁹"
    supers = dict(zip(normal, superscripts))
    s = "".join(supers.get(c, c) for c in s.lower())
    return s

def unvoweled(s):
    return re.sub(r"[^bcdfghjklmnpqrstvwxyz0123456789]", "", s.lower())


now = datetime.datetime.now()
print(f"{now:%-I:%M\n%b\u2009%-d}")

batt = run(["pmset", "-g", "batt"])
m = re.search(r"\d+%", batt)
if m:
    level = m.group(0)
    batt_percent = int(level[:-1])
else:
    level = "??%"
charging = False
if "discharging" in batt:
    arrow = "-"     #"\u25bc"        # BLACK DOWN-POINTING TRIANGLE
elif "charging" in batt:
    arrow = "+"     #"\u25b3"        # WHITE UP-POINTING TRIANGLE
    charging = True
else:
    arrow = ""

print(level + arrow)
batt_picture = gauge(batt_percent) + block_eighths(1) #"\u2578")   # BOX DRAWINGS HEAVY LEFT
#if charging:
#    batt_picture = batt_picture[0] + "\u035b" + batt_picture[1:]
print(batt_picture)

vol = run(["osascript", "-e", "get volume settings"])
m = re.search(r"^output volume:(\d+), .* muted:(\w+)", vol)
if m:
    level, muted = m.groups()
    if muted == 'true':
        level = "\u20e5"        # COMBINING REVERSE SOLIDUS OVERLAY
    print(f"\u24cb{level}")     # CIRCLED LATIN CAPITAL LETTER V

wifi = run(["/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport", "--getinfo"])
m = re.search(r"lastTxRate: (\d+)", wifi)
if m:
    wifi_speed = m.group(1)
    print(f"{wifi_speed}\u2933")
m = re.search(r" SSID: (.+)$", wifi, flags=re.MULTILINE)
if m:
    ssid = m.group(1).strip()
    #ssid = supered(unvoweled(ssid))
    ssid = ssid[:3] + ssid[-2:]
    print(ssid)

# For debugging: output the raw data, but pushed out of view.
print(f"{'':30}{batt!r}")
print(f"{'':30}{vol}")
