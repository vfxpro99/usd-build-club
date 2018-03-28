ECHO buiding glew

SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "glew-build-club/README.md" ^
git clone https://github.com/vfxpro99/glew-build-club.git

cd glew-build-club
git pull
cd ..

cd ..
xcopy .\prereq\glew-build-club\include\GL\*.* .\local\include\GL\ /s /y

cd .\prereq\glew-build-club
if not exist "build_win" mkdir build_win
cd build_win

REM cl /c -DGLEW_BUILD -DSTATIC -DGLEW_STATIC -I"%current%\local\include" ..\src\glew.c
REM lib /out:glew32s.lib glew.obj

cl /c -DGLEW_BUILD -I"%current%\local\include" ..\src\glew.c
link /dll /out:glew.dll glew.obj opengl32.lib

REM cl /c -DSTATIC -DGLEW_MX -DGLEW_BUILD -I"%current%\local\include" ..\src\glew.c
REM lib /out:glew_mx_static.lib glew.obj
REM cl /c -DGLEW_MX -DGLEW_BUILD -I"%current%\local\include" ..\src\glew.c
REM link /dll /out:glew_mx.dll glew.obj opengl32.lib

xcopy *.lib "%current%\local\lib\" /s /y
xcopy *.dll "%current%\local\bin\" /s /y

cd %current%

