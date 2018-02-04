
ECHO building ptex
SET current=%cd%

if not exist "prereq" ^
mkdir prereq

cd prereq

if not exist "ptex\CMakeLists.txt" ^
git clone https://github.com/wdas/ptex.git

cd ptex
git pull
cd ..

if not exist "build\ptex" ^
mkdir build\ptex

cd build\ptex

cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexCache.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexFilters.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexHalf.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexReader.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexSeparableFilter.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexSeparableKernel.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexTriangleFilter.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexTriangleKernel.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexUtils.cpp
cl /c -DPTEXAPI="" -I"%current%\local\include"  -wd4800 -wd4244 -D_CRT_SECURE_NO_WARNINGS /EHsc ..\..\ptex\src\ptex\PtexWriter.cpp

lib -out:ptex.lib PtexCache.obj PtexFilters.obj PtexHalf.obj PtexReader.obj ^
 PtexSeparableFilter.obj PtexSeparableKernel.obj PtexTriangleFilter.obj PtexTriangleKernel.obj ^
 PtexUtils.obj PtexWriter.obj

copy ptex.* ..\..\..\local\lib\
cd ..\..\..

copy prereq\ptex\src\ptex\PtexHalf.h local\include\PtexHalf.h
copy prereq\ptex\src\ptex\PtexInt.h local\include\PtexInt.h
copy prereq\ptex\src\ptex\Ptexture.h local\include\Ptexture.h
copy prereq\ptex\src\ptex\PtexUtils.h local\include\PtexUtils.h
copy prereq\ptex\src\ptex\PtexVersion.h local\include\PtexVersion.h

