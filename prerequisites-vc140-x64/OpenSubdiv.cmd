SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "build\OpenSubdiv" ^
mkdir build\OpenSubdiv

if not exist "OpenSubdiv\CMakeLists.txt" ^
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git

cd OpenSubdiv
git pull
cd ..

cd build\OpenSubdiv

REM Optional Stuff:
REM -DCUDA_TOOLKIT_ROOT_DIR=[path to CUDA Toolkit]
REM -DMAYA_LOCATION=[path to Maya]
REM ptex is disabled because the OpenSubdiv version detection seems broken

cmake -G "Visual Studio 14 2015 Win64"^
      -DPTEX_LOCATION=%current%/local/^
      -DGLEW_LOCATION=%current%/local^
      -DGLFW_LOCATION=%current%/local^
      -DTBB_LOCATION=%current%/local^
      -DNO_EXAMPLES=0^
      -DNO_TUTORIALS=0^
      -DNO_REGRESSION=0^
      -DNO_MAYA=1^
      -DNO_PTEX=1^
      -DNO_DOC=1^
      -DNO_OMP=1^
      -DNO_TBB=0^
      -DNO_CUDA=1^
      -DNO_OPENCL=1^
      -DNO_OPENGL=0^
      -DNO_CLEW=0^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DGLEW_LOCATION="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..\..\OpenSubdiv

rem msbuild OpenSubdiv.sln /t:Build /p:Configuration=Release /p:Platform=x64
echo "Building OpenSubdiv Debug"
cmake --build . --target install --config Debug -- /maxcpucount:8

cd ..\..\..\local\lib
ren osdCPU.lib osdCPU_debug.lib
ren osdGPU.lib osdGPU_debug.lib
cd ..\..\prereq\build\OpenSubdiv

echo "Building OpenSubdiv Release"
cmake --build . --target install --config Release -- /maxcpucount:8

cd %current%

rem xcopy .\prereq\OpenSubdiv\build\OpenSubdiv\lib\Release\*.lib .\local\lib\ /s /y
rem xcopy .\prereq\OpenSubdiv\opensubdiv\*.h .\local\include\opensubdiv\ /s /y
