ECHO building TBB
set SCRIPT_DIR=%~dp0

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "tbb.zip" ^
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://www.threadingbuildingblocks.org/sites/default/files/software_releases/windows/tbb44_20160526oss_win_0.zip', 'tbb.zip')"

if not exist "tbb44_20160526oss\README" ^
7z x .\tbb.zip

cd ..
xcopy .\prereq\tbb44_20160526oss\lib\intel64\vc14\tbb.* .\local\lib\ /s /y
xcopy .\prereq\tbb44_20160526oss\lib\intel64\vc14\tbb_debug.* .\local\lib\ /s /y
xcopy .\prereq\tbb44_20160526oss\bin\intel64\vc14\tbb.* .\local\bin\ /s /y
xcopy .\prereq\tbb44_20160526oss\bin\intel64\vc14\tbb_debug.* .\local\bin\ /s /y
xcopy .\prereq\tbb44_20160526oss\include\serial\*.* .\local\include\serial\ /s /y
xcopy .\prereq\tbb44_20160526oss\include\tbb\*.* .\local\include\tbb\ /s /y
xcopy "%SCRIPT_DIR%tbb_config.h" .\local\include\tbb\ /s /y
