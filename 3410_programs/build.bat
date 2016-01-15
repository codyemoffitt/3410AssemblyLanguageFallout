@echo off
cls

set EXE_NAME=fallout
del %EXE_NAME%.exe
del %EXE_NAME%.obj
del %EXE_NAME%.lst
del %EXE_NAME%.ilk
del %EXE_NAME%.pdb

set DRIVE_LETTER=%1:
set PATH=%DRIVE_LETTER%\Assembly\bin;c:\Windows
set INCLUDE=%DRIVE_LETTER%\Assembly\include
set LIB_DIRS=%DRIVE_LETTER%\Assembly\lib
set LIBS=strutils.obj

ml -Zi -c -coff -Fl falloutdriver.asm
ml -Zi -c -coff -Fl falloutprocs.asm
link /libpath:%LIB_DIRS% falloutdriver.obj falloutprocs.obj %LIBS% io.obj kernel32.lib /debug /out:%EXE_NAME%.exe /subsystem:console /entry:start
%EXE_NAME% <fallout.txt
