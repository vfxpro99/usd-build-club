ECHO Building boost

SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

ECHO fetching boost archive
if not exist "boost.tar.gz" ^
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://downloads.sourceforge.net/sourceforge/boost/boost_1_63_0.tar.gz', 'boost.tar.gz')"

ECHO unzipping boost archive
if not exist "boost.tar" ^
7z x boost.tar.gz

ECHO untarring boost tarball
if not exist "boost_1_63_0\INSTALL" ^
7z x -ttar boost.tar

if not exist "boost-build-club\README.md" ^
git clone https://github.com/vfxpro99/boost-build-club.git

cd boost-build-club
git pull
cd ..

EChO building boost
xcopy .\boost-build-club\* .\boost_1_63_0\ /s /y
cd .\boost_1_63_0
call build-win-shared.bat

cd ..\..
xcopy .\prereq\boost_1_63_0\stage\lib\*.lib .\local\lib\ /s /y /q
xcopy .\prereq\boost_1_63_0\stage\lib\*.dll .\local\bin\ /s /y /q
xcopy .\prereq\boost_1_63_0\boost\* .\local\include\boost\ /s /y /q
