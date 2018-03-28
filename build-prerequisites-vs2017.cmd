REM ensure a 64 bit development environment using VS2017
IF NOT "%VisualStudioVersion%"=="15.0" call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"

call ..\usd-build-club\prerequisites-vc150-x64\python.cmd
call ..\usd-build-club\prerequisites-vc150-x64\zlib.cmd
call ..\usd-build-club\prerequisites-vc150-x64\jpeg.cmd
call ..\usd-build-club\prerequisites-vc150-x64\png.cmd
call ..\usd-build-club\prerequisites-vc150-x64\tiff.cmd
REM call ..\usd-build-club\prerequisites-vc150-x64\double-conversion.cmd
call ..\usd-build-club\prerequisites-vc150-x64\boost_vs2017_5.cmd
call ..\usd-build-club\prerequisites-vc150-x64\tbb.cmd
call ..\usd-build-club\prerequisites-vc150-x64\glew.cmd
call ..\usd-build-club\prerequisites-vc150-x64\glext.cmd
call ..\usd-build-club\prerequisites-vc150-x64\openexr.cmd
call ..\usd-build-club\prerequisites-vc150-x64\ptex.cmd
call ..\usd-build-club\prerequisites-vc150-x64\OpenSubdiv.cmd
call ..\usd-build-club\prerequisites-vc150-x64\OpenImageIO.cmd
REM call ..\usd-build-club\prerequisites-vc150-x64\hdf5.cmd
call ..\usd-build-club\prerequisites-vc150-x64\alembic.cmd

