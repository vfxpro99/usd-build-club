
@echo off

REM arguments: debug, to build debug instead of release
REM            prereq, to build the prerequisites before performing the main build

SET current=%cd%

REM ensure a 64 bit development environment using VS2015
IF NOT "%VisualStudioVersion%"=="14.0" ^
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64

REM check for required helper apps
where /q cmake
IF ERRORLEVEL 1 (
    ECHO Cmake is missing. Ensure it is installed and placed in your PATH.
    EXIT /B
) ELSE (
    ECHO Cmake found
)
where /q 7z
IF ERRORLEVEL 1 (
    ECHO 7z is missing. Ensure it is installed and placed in your PATH.
    EXIT /B
) ELSE (
    ECHO 7z found
)
where /q nasm
IF ERRORLEVEL 1 (
    ECHO nasm is missing. Ensure it is installed and placed in your PATH.
    EXIT /B
) ELSE (
    ECHO nasm found
)
where /q git
IF ERRORLEVEL 1 (
    ECHO git is missing. Ensure it is installed and placed in your PATH.
    EXIT /B
) ELSE (
    ECHO git found
)
where /q python
IF ERRORLEVEL 1 (
    ECHO Python 2.7 is missing. Ensure it is installed at C:\Python27 and placed in your PATH.
    EXIT /B
) ELSE (
    ECHO Python found
)

REM arguments
set prereq=false
IF "%~1"=="prereq" (set prereq=true)
IF "%~2"=="prereq" (set prereq=true)

set release=true
IF "%~1"=="debug" (set release=false)
IF "%~2"=="debug" (set release=false)
IF "%~1"=="Debug" (set release=false)
IF "%~2"=="Debug" (set release=false)

set debug=release
if NOT "%release%"=="true" (set debug=debug)

REM prerequisites
IF NOT "%prereq%"=="true" GOTO Build

echo "Building prerequisite libraries for USD"
cd %current%
call ..\usd-build-club\build-prerequisites-windows.cmd %debug%

:Build

echo "Fetching latest USD"
cd %current%
cd ..
if not exist "USD/.git/config" ^
git clone https://github.com/PixarAnimationStudios/USD.git
cd USD
git checkout dev
git pull

cd %current%
call ..\usd-build-club\configure-windows.cmd %debug%

IF "%release%"=="true" GOTO BuildRelease

echo "Building as Debug USD"
cd %current%\prereq\build\USD
cmake --build . --target install --config Debug -- /maxcpucount:16
GOTO Finished

:BuildRelease

echo "Building as Release USD"
cd %current%\prereq\build\USD
cmake --build . --target install --config Release -- /maxcpucount:16

:Finished
