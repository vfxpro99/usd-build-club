REM ensure a 64 bit development environment using VS2015
IF NOT "%VisualStudioVersion%"=="14.0" ^
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64

call ..\usd-build-club\prerequisites-vc140-x64\python.cmd
call ..\usd-build-club\prerequisites-vc140-x64\zlib.cmd
call ..\usd-build-club\prerequisites-vc140-x64\ptex.cmd
call ..\usd-build-club\prerequisites-vc140-x64\jpeg.cmd
call ..\usd-build-club\prerequisites-vc140-x64\png.cmd
call ..\usd-build-club\prerequisites-vc140-x64\tiff.cmd
call ..\usd-build-club\prerequisites-vc140-x64\double-conversion.cmd
call ..\usd-build-club\prerequisites-vc140-x64\boost.cmd
call ..\usd-build-club\prerequisites-vc140-x64\tbb.cmd
call ..\usd-build-club\prerequisites-vc140-x64\glew.cmd
call ..\usd-build-club\prerequisites-vc140-x64\glext.cmd
call ..\usd-build-club\prerequisites-vc140-x64\openexr.cmd
call ..\usd-build-club\prerequisites-vc140-x64\OpenSubdiv.cmd
call ..\usd-build-club\prerequisites-vc140-x64\OpenImageIO.cmd
rem call ..\usd-build-club\prerequisites-vc140-x64\hdf5.cmd
call ..\usd-build-club\prerequisites-vc140-x64\alembic.cmd

if "%~1" == debug (
    cd .\local\lib
    del osdCPU.lib
    ren osdCPU_debug.lib osdCPU.lib
    del osdGPU.lib
    ren osdGPU_debug.lib osdGPU.lib
    cd ..\bin
    del osdCPU.dll
    ren osdCPU_debug.dll osdCPU.dll
    del osdGPU.dll
    ren osdGPU_debug.dll osdGPU.dll
    cd ..\..
)
