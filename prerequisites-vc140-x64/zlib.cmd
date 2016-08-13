SET current=%cd%
cd prereq
git clone git://github.com/madler/zlib.git

if not exist "build\zlib" mkdir build\zlib
cd build\zlib

cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX="%current%" ..\..\zlib
msbuild zlib.sln /t:Build /p:Configuration=Release /p:Platform=x64
cd %current%
xcopy .\prereq\zlib\zlib.h .\local\include\ /s /y
xcopy .\prereq\build\zlib\zconf.h .\local\include /s /y
xcopy .\prereq\build\zlib\Release\zlib.* .\local\lib /s /y
