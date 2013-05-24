@echo off

set fbc="C:\Program Files\FBEdit\FreeBASIC\fbc.exe"

set source=ege/ege.bi

rem outputdir must not end with a \
set outputdir=lib

set libname=ege
set dlibname=eged

rem build debug lib
%fbc% -b %source% -lib -g -x "%outputdir%\%dlibname%"

rem build release lib
%fbc% -b %source% -lib -x "%outputdir%\%libname%"

echo.
echo Done.
echo.