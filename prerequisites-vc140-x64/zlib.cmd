SET current=%cd%
cd prereq

if not exist "zlib/CMakeLists.txt" ^
git clone git://github.com/madler/zlib.git

cd zlib
git pull
cd ..

if not exist "build\zlib" ^
mkdir build\zlib

cd build\zlib

cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX="%current%" ..\..\zlib
cmake --build . --target install --config Release
rem msbuild zlib.sln /t:Build /p:Configuration=Release /p:Platform=x64
cd %current%
rem xcopy .\prereq\zlib\zlib.h .\local\include\ /s /y
rem xcopy .\prereq\build\zlib\zconf.h .\local\include /s /y
rem xcopy .\prereq\build\zlib\Release\zlib.* .\local\lib /s /y
