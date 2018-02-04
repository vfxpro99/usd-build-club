ECHO building zlib
SET current=%cd%

if not exist "prereq" ^
mkdir prereq

cd prereq

if not exist "zlib/CMakeLists.txt" ^
git clone git://github.com/madler/zlib.git

cd zlib
git pull
cd ..

if not exist "build\zlib" ^
mkdir build\zlib

cd build\zlib

cmake -G "Visual Studio 15 2017 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local"^
      ..\..\zlib
cmake --build . --target install --config Release -- /maxcpucount:8

cd %current%

rem // xcopy .\inst\zlib\include\* .\local\include\ /s /y
rem // xcopy .\inst\zlib\lib\* .\local\lib\ /s /y
