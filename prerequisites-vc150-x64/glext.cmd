
ECHO Getting glext.h

set stage=%cd%

if not exist "local/include/GL" ^
mkdir local/include/GL
cd local/include/GL

if not exist "glext.h" ^
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://www.opengl.org/registry/api/GL/glext.h', 'glext.h')"

cd %stage%
