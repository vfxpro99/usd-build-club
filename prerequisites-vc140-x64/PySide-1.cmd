::
:: Build helper for Pixar's USD open source distro.
:: Copyright © 2016 by Jamie Kenyon <jamie_kenyon@hotmail.com>
::
:: Licensed under GNU General Public License 3.0 or later. 
::
:: Arguments:
::      TARGET_DIR - Path to install the build artefacts into.
::      SCRATCH_DIR - Path to use for downloading and building.
::
::----------------------------------------------------------------------------
@echo off
setlocal

:: Get the command line paramters.
set TARGET_DIR=C:\Data\Output
set SCRATCH_DIR=C:\Data\Temp
set MYQMAKE=C:\data\_Usd_Deps\bin\QMake.exe

:: Switch to the temporary directory.
pushd
cd %SCRATCH_DIR%

:: Download the source.
set URL=https://pypi.python.org/packages/source/P/PySide/PySide-1.2.4.tar.gz
if not exist "%SCRATCH_DIR%\PySide-1.2.4.tar.gz" (
	powershell -Command "Invoke-WebRequest %URL% -OutFile Pyside.tar.gz"
)	
	:: Extract.
	7z x "Pyside.tar.gz" -so | 7z x -aoa -si -ttar -o"Pyside"


:: Set the MSVC build environment.
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x64

cd %SCRATCH_DIR%\Pyside\PySide-1.2.4

:: Invoke the build script.
C:\Python27\Python.exe setup.py bdist_wininst --qmake=%MYQMAKE%

:: That's it, we're done!
popd
goto :Done


   
    
:Done
:: We're done. 
:: The script will now terminate.
