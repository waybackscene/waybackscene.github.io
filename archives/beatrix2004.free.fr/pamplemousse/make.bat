@echo off
echo Keygen par BeatriX^FRET.
set name=AntiPamplemousse

if exist %name%.exe del %name%.exe
if exist %name%.obj del %name%.obj
if exist rsrc.obj   del rsrc.obj

echo Creation des ressources
echo.
\masm32\bin\rc rsrc.rc
\masm32\bin\cvtres /machine:ix86 rsrc.res

echo Compilation de SHA1.asm...
\masm32\bin\ml /c /coff SHA_1.asm

echo Compilation de Antipamplemousse.c...
\lcc\bin\lcc -O -I\lcc\include %name%.c

echo.
echo Linkage en cours...
\lcc\bin\lcclnk -s -subsystem windows %name%.obj rsrc.obj SHA_1.obj ms32.lib
echo.
echo Suppression des fichiers inutiles
echo.
if exist %name%.obj del %name%.obj
if exist rsrc.obj   del rsrc.obj
if exist rsrc.RES   del rsrc.RES
if exist SHA_1.obj del SHA_1.obj
rem fsg.exe %name%.exe

echo.
echo.
echo.
echo                          *******************************************
echo                                 %name%.exe cree avec succes !!!     
echo                          *******************************************

echo.
echo.
echo.
pause





