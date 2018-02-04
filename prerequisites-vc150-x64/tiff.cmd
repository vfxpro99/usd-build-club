ECHO building tiff
SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "build\libtiff" ^
git clone https://github.com/vadz/libtiff

cd libtiff
git pull
cd ..

if not exist "build\libtiff" ^
mkdir build\libtiff

cd build\libtiff

cmake -G "Visual Studio 15 2017 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\libtiff

cmake --build . --target install --config Release -- /maxcpucount:8

rem msbuild tiff.sln /t:Build /p:Configuration=Release /p:Platform=x64
cd %current%
rem xcopy .\prereq\libtiff\build_win\libtiff\Release\tiff.* .\local\lib\ /s /y
rem xcopy .\prereq\libtiff\libtiff\tiff*.h .\local\include\ /s /y
