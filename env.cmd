@echo off
REM $Id$
echo -- c:\ned\env.cmd --

REM Tell Cygwin not to chatter about backslashes in filenames.
set CYGWIN=nodosfilewarning

REM The first time through this file, save the original values of things we
REM add on to, so we can run the file again and they won't grow without bound.

if "%ORIGPATH%x" == "x" set ORIGPATH=%PATH%
if "%ORIGCLASSPATH%x" == "x" set ORIGCLASSPATH=%CLASSPATH%
if "%ORIGPATHEXT%x" == "x" set ORIGPATHEXT=%PATHEXT%
if "%ORIGINCLUDE%x" == "x" set ORIGINCLUDE=%INCLUDE%
if "%ORIGLIB%x" == "x" set ORIGLIB=%LIB%
if "%ORIGPYTHONPATH%x" == "x" set ORIGPYTHONPATH=%PYTHONPATH%

set PATH=%ORIGPATH%
set CLASSPATH=%ORIGCLASSPATH%
set PATHEXT=%ORIGPATHEXT%
set INCLUDE=%ORIGINCLUDE%
set LIB=%ORIGLIB%
set PYTHONPATH=%ORIGPYTHONPATH%

set HOME=c:\ned
set EDITOR=vim

REM call "%VS71COMNTOOLS%\vsvars32.bat"

set PATH=.;%HOME%\bin;%PATH%;c:\cygwin\bin;c:\app\MinGW\bin

set CLASSPATH=%ORIGCLASSPATH%;.

REM For running python.
set PYTHONPATH=%PYTHONPATH%;%HOME%\py
set PATH=%PATH%;%HOME%\py\stellated\scripts
set PYTHONSTARTUP=%HOME%\.startup.py

REM Set the PYHOME environment var.
python -c "import os,sys; print 'set PYHOME=%%s' %% sys.exec_prefix.replace(chr(92), '/')" >%TEMP%\pyhome.bat
call %TEMP%\pyhome.bat

set PIP_DOWNLOAD_CACHE=c:\kit\cache_pypi
