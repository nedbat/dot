@echo off
xdir.py %* >%TEMP%\__xdir.cmd
call %TEMP%\__xdir.cmd
