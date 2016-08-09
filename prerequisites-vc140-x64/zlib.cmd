SET current=%cd%
cd prereq
git clone git://github.com/madler/zlib.git
cd zlib
mkdir build_win
cd build_win
cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX="%current%" ..
msbuild zlib.sln /t:Build /p:Configuration=Release /p:Platform=x64
cd %current%
xcopy .\prereq\zlib\zlib.h .\local\include\ /s /y
xcopy .\prereq\zlib\build_win\zconf.g .\local\include /s /y
xcopy .\prereq\zlib\build_win\Release\zlib.* .\local\lib /s /y
