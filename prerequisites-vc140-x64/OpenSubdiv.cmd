SET current=%cd%
cd prereq

if not exist "build\OpenSubdiv" ^
mkdir build\OpenSubdiv

if not exist "OpenSubdiv\CMakeLists.txt" ^
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git

cd OpenSubdiv
git pull
cd ..

cd build\OpenSubdiv

cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DGLEW_LOCATION="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\OpenSubdiv

rem msbuild OpenSubdiv.sln /t:Build /p:Configuration=Release /p:Platform=x64
cmake --build . --target install --config Release

cd %current%

rem xcopy .\prereq\OpenSubdiv\build\OpenSubdiv\lib\Release\*.lib .\local\lib\ /s /y
rem xcopy .\prereq\OpenSubdiv\opensubdiv\*.h .\local\include\opensubdiv\ /s /y
