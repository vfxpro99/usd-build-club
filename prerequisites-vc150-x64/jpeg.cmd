
ECHO building libjpeg-turbo

where /q nasm
IF ERRORLEVEL 1 (
    ECHO nasm is missing. Ensure it is installed and placed in your PATH.
    EXIT /B
) ELSE (
    ECHO nasm found
)

SET current=%cd%

if not exist "prereq" ^
mkdir prereq

cd prereq

git clone https://github.com/libjpeg-turbo/libjpeg-turbo.git

if not exist "build\libjpeg-turbo" mkdir build\libjpeg-turbo
cd build\libjpeg-turbo

cmake -G "Visual Studio 15 2017 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\libjpeg-turbo

cmake --build . --target install --config Release -- /maxcpucount:8

rem msbuild libjpeg-turbo.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd %current%
rem xcopy .\prereq\libjpeg-turbo\build_win\Release\turbojpeg.* .\local\lib\ /s /y
rem xcopy .\prereq\libjpeg-turbo\turbojpeg*.h .\local\include\ /s /y
