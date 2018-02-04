ECHO Building boost

IF NOT "%VisualStudioVersion%"=="15.0" call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"

SET current=%cd%

if not exist "prereq" mkdir prereq
cd prereq

ECHO fetching boost archive
if not exist "boost_1_65_1.tar.gz" ^
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://downloads.sourceforge.net/sourceforge/boost/boost_1_65_1.tar.gz', 'boost_1_65_1.tar.gz')"

ECHO unzipping boost archive
if not exist "boost_1_65_1.tar" ^
7z x boost_1_65_1.tar.gz

ECHO untarring boost tarball
if not exist "boost_1_65_1\INSTALL" ^
7z x -ttar boost_1_65_1.tar

if not exist "boost-build-scripts\README.md" ^
git clone https://github.com/vfxpro99/boost-build-scripts.git

cd boost-build-scripts
git pull
cd ..

EChO building boost
xcopy .\boost-build-scripts\* .\boost_1_65_1\ /s /y
cd .\boost_1_65_1

rem Directory to boost root
set boost_dir=boost_1_65_1

rem Number of cores to use when building boost
set cores=%NUMBER_OF_PROCESSORS%

rem What toolset to use when building boost.

rem Visual Studio 2012 -> set msvcver=msvc-11.0
rem Visual Studio 2013 -> set msvcver=msvc-12.0
rem Visual Studio 2015 -> set msvcver=msvc-14.0
rem Visual Studio 2017 -> set msvcver=msvc-14.1

set msvcver=msvc-14.1

rem Start building boost
echo Building %boost_dir% with %cores% cores using toolset %msvcver%.

cd %boost_dir%
call bootstrap.bat

rem Static libraries
rem b2 -j%cores% toolset=%msvcver% address-model=64 architecture=x86 link=static threading=multi runtime-link=shared --build-type=minimal stage --stagedir=stage/x64 
rem b2 -j%cores% toolset=%msvcver% address-model=32 architecture=x86 link=static threading=multi runtime-link=shared --build-type=minimal stage --stagedir=stage/win32

rem Build DLLs
b2 -j%cores% toolset=%msvcver% address-model=64 architecture=x86 link=shared threading=multi runtime-link=shared --build-type=minimal stage --stagedir=stage/x64 
rem b2 -j%cores% toolset=%msvcver% address-model=32 architecture=x86 link=shared threading=multi runtime-link=shared --build-type=minimal stage --stagedir=stage/win32

cd ..\..
xcopy .\prereq\boost_1_65_1\stage\x64\lib\*.lib .\local\lib\           /s /y /q
xcopy .\prereq\boost_1_65_1\stage\x64\lib\*.dll .\local\bin\           /s /y /q
xcopy .\prereq\boost_1_65_1\boost\*         .\local\include\boost\ /s /y /q
