SET current=%cd%
cd prereq

if not exist "ptex\CMakeLists.txt" ^
git clone https://github.com/wdas/ptex.git

cd ptex
git pull
cd ..

if not exist "build\ptex" ^
mkdir build\ptex

cd build\ptex

cmake -G "Visual Studio 14 2015 Win64" ^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ^
      -DZLIB_INCLUDE_DIR="%current%\local\include" ^
      -DZLIB_LIBRARY="%current%\local\lib\zlib.lib" ^
      ..\..\ptex

if exist "ptex.sln" ^
cmake --build . --target install --config Release

cd ../../..

