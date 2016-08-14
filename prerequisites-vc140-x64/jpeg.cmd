echo building libjpeg-turbo requires nasm available from
echo http://www.nasm.us/pub/nasm/releasebuilds
echo nasm must be in the path.

SET current=%cd%
cd prereq
git clone https://github.com/libjpeg-turbo/libjpeg-turbo.git

if not exist "build/libjpeg-turbo" mkdir build/libjpeg-turbo
cd build/libjpeg-turbo

cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\libjpeg-turbo

cmake --build . --target install --config Release

rem msbuild libjpeg-turbo.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd %current%
rem xcopy .\prereq\libjpeg-turbo\build_win\Release\turbojpeg.* .\local\lib\ /s /y
rem xcopy .\prereq\libjpeg-turbo\turbojpeg*.h .\local\include\ /s /y
