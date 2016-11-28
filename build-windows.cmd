
REM arguments: debug, to build debug instead of release
REM            prereq, to build the prerequisites before performing the main build

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
set prereq=true
IF NOT "%~1"=="prereq" IF NOT "%~2"=="prereq" set prereq=false

set release=true
IF NOT "%~1"=="debug" IF NOT "%~2"=="debug" set release=false

REM prerequisites
IF NOT "%prereq%"=="true" GOTO Build

echo "Building prerequisite libraries for USD"
call ..\usd-build-club\build_prerequisites.cmd

:Build

call ..\usd-build-club\configure.cmd

IF "%release%"=="true" GOTO BuildRelease

echo "Building as Debug USD"
cmake --build . --target install --config Debug -- /maxcpucount:16
GOTO Finished

:BuildRelease

echo "Building as Release USD"
cmake --build . --target install --config Release -- /maxcpucount:16

:Finished
