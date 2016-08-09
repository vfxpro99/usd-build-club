SET current=%cd%
cd prereq
git clone https://github.com/google/double-conversion.git

cd double-conversion
mkdir build_win
cd build_win
cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX="%current%" ..
msbuild double-conversion.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd ../../..
copy .\prereq\double-conversion\build_win\double-conversion\Release\double-conversion.lib .\local\lib\
xcopy .\prereq\double-conversion\double-conversion\*.h .\local\include\double-conversion\ /s /y
