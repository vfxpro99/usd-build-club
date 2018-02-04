ECHO setting up Python
REM echo Warning, this script hacks pyconfig.h to disable the autolinking of python_d.lib
REM SCRIPT_DIR=%~dp0
REM xcopy "%SCRIPT_DIR%pyconfig.h" "c:\Python27\include\pyconfig.h" /s /y

pip install jinja2
