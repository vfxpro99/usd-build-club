ECHO building double-conversion

SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "double-conversion\CMakeLists.txt" ^
git clone https://github.com/google/double-conversion.git

cd double-conversion
git pull
cd ..

if not exist "build\double-conversion" ^
mkdir build\double-conversion

cd build\double-conversion

cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local"^
      ..\..\double-conversion

cmake --build . --target install --config Release
rem msbuild double-conversion.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd ../../..
rem copy .\prereq\build\double-conversion\double-conversion\Release\double-conversion.lib .\local\lib\
rem xcopy .\prereq\double-conversion\double-conversion\*.h .\local\include\double-conversion\ /s /y

