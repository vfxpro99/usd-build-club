
SET current=%cd%
SET builddir=%cd%\local

IF NOT "%VisualStudioVersion%"=="14.0" ^
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64

SET PATH=%PATH%;%builddir%\lib;%builddir%\bin
SET PYTHONPATH=%PYTHONPATH%;%builddir%\lib\python
