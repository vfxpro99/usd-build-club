SET current=%cd%
cd prereq
git clone git://github.com/meshula/openexr.git
cd openexr
mkdir build_win
cd build_win
mkdir IlmBase
cd IlmBase
cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\IlmBase
msbuild ilmBase.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd %current%
xcopy .\prereq\openexr\build_win\IlmBase\config\*.* .\local\include\OpenEXR\ /s /y
xcopy .\prereq\openexr\build_win\IlmBase\Half*.h .\local\include\OpenEXR\ /s /y
xcopy .\prereq\openexr\IlmBase\Half\*.h .\local\include\OpenEXR\ /s /y
xcopy .\prereq\openexr\IlmBase\Iex\*.h .\local\include\OpenEXR\ /s /y
xcopy .\prereq\openexr\IlmBase\IexMath\*.h .\local\include\OpenEXR\ /s /y
xcopy .\prereq\openexr\IlmBase\IlmThread\*.h .\local\include\OpenEXR\ /s /y
xcopy .\prereq\openexr\IlmBase\Imath\*.h .\local\include\OpenEXR\ /s /y

xcopy .\prereq\openexr\build_win\IlmBase\Half\Release\Half.* .\local\lib\ /s /y
xcopy .\prereq\openexr\build_win\IlmBase\Iex\Release\Iex-2_2.* .\local\lib\ /s /y
xcopy .\prereq\openexr\build_win\IlmBase\IexMath\Release\IexMath-2_2.* .\local\lib\ /s /y
xcopy .\prereq\openexr\build_win\IlmBase\IlmThread\Release\IlmThread-2_2.* .\local\lib\ /s /y
xcopy .\prereq\openexr\build_win\IlmBase\Imath\Release\Imath-2_2.* .\local\lib\ /s /y

cd .\prereq\openexr\build_win
mkdir OpenEXR
cd OpenEXR
cmake -G "Visual Studio 14 2015 Win64" -DILMBASE_PACKAGE_PREFIX="%current%\local" -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\OpenEXR
msbuild openEXR.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd %current%

xcopy .\prereq\openexr\build_win\OpenEXR\IlmImf\Release\IlmImf*.lib .\local\lib\ /s /y
xcopy .\prereq\openexr\build_win\OpenEXR\IlmImf\Release\IlmImf*.dll .\local\bin\ /s /y
xcopy .\prereq\openexr\build_win\OpenEXR\exrenvmap\Release\*.exe .\local\bin\ /s /y
xcopy .\prereq\openexr\build_win\OpenEXR\exrheader\Release\*.exe .\local\bin\ /s /y
xcopy .\prereq\openexr\build_win\OpenEXR\exrmakepreview\Release\*.exe .\local\bin\ /s /y
xcopy .\prereq\openexr\build_win\OpenEXR\exrmultipart\Release\*.exe .\local\bin\ /s /y
xcopy .\prereq\openexr\build_win\OpenEXR\exrmultiview\Release\*.exe .\local\bin\ /s /y
xcopy .\prereq\openexr\build_win\OpenEXR\exrstdattr\Release\*.exe .\local\bin\ /s /y
