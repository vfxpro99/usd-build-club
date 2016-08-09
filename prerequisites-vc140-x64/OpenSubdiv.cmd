SET current=%cd%
cd prereq
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git
cd OpenSubdiv
mkdir build_win
cd build_win
cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DGLEW_LOCATION="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..
msbuild OpenSubdiv.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd %current%

xcopy .\prereq\OpenSubdiv\build_win\lib\Release\*.lib .\local\lib\ /s /y
xcopy .\prereq\OpenSubdiv\opensubdiv\*.h .\local\include\opensubdiv\ /s /y
