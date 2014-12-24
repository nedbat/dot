@echo off
echo -- c:\ned\start.cmd --

title Cmd

call c:\ned\env.cmd

set PROMPT=$P$G$S
set DIRCMD=/o

doskey u=xdir.cmd cd .. $*
doskey uu=xdir.cmd cd .. .. $*
doskey uuu=xdir.cmd cd .. .. .. $*
doskey uuuu=xdir.cmd cd .. .. .. .. $*
doskey uuuuu=xdir.cmd cd .. .. .. .. .. $*

doskey x=xdir.cmd cd $*
doskey ux=xdir.cmd cd .. $*
doskey uux=xdir.cmd cd .. .. $*
doskey uuux=xdir.cmd cd .. .. .. $*
doskey uuuux=xdir.cmd cd .. .. .. .. $*
doskey uuuuux=xdir.cmd cd .. .. .. .. .. $*

doskey xp=xdir.cmd push $*
doskey uxp=xdir.cmd push .. $*
doskey uuxp=xdir.cmd push .. .. $*
doskey uuuxp=xdir.cmd push .. .. .. $*
doskey uuuuxp=xdir.cmd push .. .. .. .. $*
doskey uuuuuxp=xdir.cmd push .. .. .. .. .. $*

doskey xb=xdir.cmd back $*
doskey xc=xdir.cmd clear $*
doskey xh=xdir.cmd history $*
doskey xp=xdir.cmd push $*
doskey xq=xdir.cmd pop $*
doskey xr=xdir.cmd roll $*
doskey xl=xdir.cmd roll $*
doskey xs=xdir.cmd showstack $*

doskey d=dir $*
doskey l=showfiles $*
rem doskey e="c:\Program Files\ActiveState Komodo Edit 5\komodo.exe" $*
doskey e=vim --servername GVIM --remote-silent $*
doskey m=less $*
doskey h=hexdump $*

doskey rm=c:\app\cygwin\bin\rm $*

doskey bc="C:\Program Files (x86)\Beyond Compare 3\BComp.exe" $*

doskey putty="c:\program files\putty\putty.exe" -load $*

doskey wf="c:\program files\putty\putty.exe" -load webfaction
