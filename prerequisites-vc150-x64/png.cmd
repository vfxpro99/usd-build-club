
ECHO building png
SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "build\libpng" ^
mkdir build\libpng

if not exist "libpng\CMakeLists.txt" ^
git clone git://github.com/glennrp/libpng.git

cd libpng
git pull
cd ..

cd build\libpng

cmake -G "Visual Studio 15 2017 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\libpng

cmake --build . --target install --config Release -- /maxcpucount:8

rem msbuild libpng.sln /t:Build /p:Configuration=Release /p:Platform=x64
cd %current%
rem xcopy .\prereq\libpng\build_win\Release\libpng*.* .\local\lib\ /s /y
rem xcopy .\prereq\libpng\png*.h .\local\include /s /y
