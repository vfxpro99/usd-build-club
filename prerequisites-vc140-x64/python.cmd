ECHO setting up Python
echo Warning, this script hacks pyconfig.h to disable the autolinking of python_d.lib
set SCRIPT_DIR=%~dp0
xcopy "%SCRIPT_DIR%pyconfig.h" "c:\Python27\include\pyconfig.h" /s /y
