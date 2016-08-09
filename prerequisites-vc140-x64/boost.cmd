cd prereq
git clone https://github.com/vfxpro99/boost-build-club.git

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://downloads.sourceforge.net/sourceforge/boost/boost_1_60_0.tar.gz', 'boost.tar.gz')"
7z x boost.tar.gz
7z x -ttar boost.tar

xcopy .\boost-build-club\* .\boost_1_60_0\ /s /y
cd .\boost_1_60_0
build-win-shared.bat

cd ..\..
xcopy .\prereq\boost_1_60_0\stage\lib\*.lib .\local\lib\ /s /y
xcopy .\prereq\boost_1_60_0\stage\lib\*.dll .\local\bin\ /s /y
xcopy .\prereq\boost_1_60_0\boost\* .\local\include\boost\ /s /y
