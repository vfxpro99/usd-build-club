ECHO building PySide
set SCRIPT_DIR=%~dp0

cd prereq

if not exist "pyside.tar.gz" ^
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://pypi.python.org/packages/source/P/PySide/PySide-1.2.4.tar.gz', 'pyside.tar.gz')"

if not exist "dist\PySide-1.2.4.tar" ^
7z x pyside.tar.gz

if not exit "PySide-1.2.4\README.rst"
7z x -ttar dist\PySide-1.2.4.tar

cd PySide-1.2.4

C:\Python27\Python.exe setup.py bdist_wininst --qmake=%MYQMAKE%
