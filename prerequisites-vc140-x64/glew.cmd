SET current=%cd%
cd prereq
git clone https://github.com/vfxpro99/glew-build-club.git
cd ..
xcopy .\prereq\glew-build-club\include\GL\*.* .\local\include\GL\ /s /y
cd .\prereq\glew-build-club
mkdir build_win
cd build_win
cl /c -DSTATIC -DGLEW_BUILD -I"%current%\local\include" ..\src\glew.c
lib /out:glew_static.lib glew.obj
cl /c -DGLEW_BUILD -I"%current%\local\include" ..\src\glew.c
link /dll /out:glew.dll glew.obj opengl32.lib
cl /c -DSTATIC -DGLEW_MX -DGLEW_BUILD -I"%current%\local\include" ..\src\glew.c
lib /out:glew_mx_static.lib glew.obj
cl /c -DGLEW_MX -DGLEW_BUILD -I"%current%\local\include" ..\src\glew.c
link /dll /out:glew_mx.dll glew.obj opengl32.lib
xcopy *.lib "%current%\local\lib\" /s /y
xcopy *.dll "%current%\local\bin\" /s /y
cd %current%
