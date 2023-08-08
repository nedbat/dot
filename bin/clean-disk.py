#!/usr/bin/env python3
"""Scrub needless files to save space"""

from pathlib import Path
import shutil
import subprocess

total_saved = 0

def command_output(cmd):
    try:
        return subprocess.check_output(cmd, shell=True).decode("utf-8")
    except Exception as exc:
        print(exc)

def path_for(dirname):
    return Path(dirname).expanduser()

def get_size(dirpath):
    if dirpath.exists():
        output = command_output(f"du -sk {dirpath}")
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
    print(f"after:  {after:15,d}")
    print(f"saved:  {before-after:15,d}")
    global total_saved
    total_saved += before - after


def rmrf(dirname):
    """Remove completely"""
    shutil.rmtree(dirname, ignore_errors=True)

def cmd(template, doc=None):
    def doit(dirname):
        print(command_output(template.format(dirname=dirname)))
    doit.__doc__ = doc or template
    return doit

rm_pyc = cmd("find {dirname} -regex '.*\.py[cow]' -delete", "Delete .pyc etc files")

clean(command_output("brew --cache").strip(), rmrf)
clean("/usr/local/pyenv/pyenv/cache", rmrf)
clean("~/Documents/Zoom", rmrf)
clean("~/Library/Caches/com.spotify.client", rmrf)
clean("~/Library/Caches/pip", rmrf)
clean("~/Library/Caches/pipenv", rmrf)
clean("~/Library/Caches/pip-tools", rmrf)
clean("~/Library/Caches/yarn", rmrf)
clean("~/.tox", rmrf)
clean("/usr/local/virtualenvs", rm_pyc)
clean("/usr/local/pyenv", rm_pyc)
clean("/usr/local/pypy", rm_pyc)
clean("/tmp/nedbatchelder-pyc", rmrf)
clean("~/log/irc", cmd("afsctool -cvv -9 {dirname}"))

print(f"----\nTOTAL:  {total_saved:15,d}")
