SET current=%cd%
cd prereq
git clone https://github.com/google/double-conversion.git

if not exist "build\double-conversion" mkdir build\double-conversion
cd build\double-conversion

cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX="%current%" ..\..\double-conversion
msbuild double-conversion.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd ../../..
copy .\prereq\build\double-conversion\double-conversion\Release\double-conversion.lib .\local\lib\
xcopy .\prereq\double-conversion\double-conversion\*.h .\local\include\double-conversion\ /s /y

