
cd prereq
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://www.threadingbuildingblocks.org/sites/default/files/software_releases/windows/tbb44_20160128oss_win_0.zip', 'tbb.zip')"
7z x .\tbb.zip
cd ..
xcopy .\prereq\tbb44_20160128oss\lib\intel64\vc14\tbb.* .\local\lib\ /s /y
xcopy .\prereq\tbb44_20160128oss\lib\intel64\vc14\tbb_debug.* .\local\lib\ /s /y
xcopy .\prereq\tbb44_20160128oss\bin\intel64\vc14\tbb.* .\local\bin\ /s /y
xcopy .\prereq\tbb44_20160128oss\bin\intel64\vc14\tbb_debug.* .\local\bin\ /s /y
xcopy .\prereq\tbb44_20160128oss\include\serial\*.* .\local\include\serial\ /s /y
xcopy .\prereq\tbb44_20160128oss\include\tbb\*.* .\local\include\tbb\ /s /y
