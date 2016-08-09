SET current=%cd%
cd prereq
git clone git://github.com/glennrp/libpng.git
cd libpng
mkdir build_win
cd build_win
cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..
msbuild libpng.sln /t:Build /p:Configuration=Release /p:Platform=x64
cd %current%
xcopy .\prereq\libpng\build_win\Release\libpng*.* .\local\lib\ /s /y
xcopy .\prereq\libpng\png*.h .\local\include /s /y
