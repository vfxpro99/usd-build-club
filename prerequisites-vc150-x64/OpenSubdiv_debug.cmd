
ECHO building OpenSubdiv

SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "build\OpenSubdiv" ^
mkdir build\OpenSubdiv

echo "Building OpenSubdiv from vfxpro99 dev fork due to GLEW issues"

if not exist "OpenSubdiv\CMakeLists.txt" ^
git clone https://github.com/vfxpro99/OpenSubdiv.git

cd OpenSubdiv
git pull
REM checkout the dev branch, since 3.0.5 ptex detection was broken by changes in ptex changes.
git checkout dev
cd ..

cd build\OpenSubdiv

REM Optional Stuff:
REM -DCUDA_TOOLKIT_ROOT_DIR=[path to CUDA Toolkit]
REM -DMAYA_LOCATION=[path to Maya]

cmake -G "Visual Studio 15 2017 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local"^
      -DPTEX_LOCATION="%current%/local/"^
      -DGLEW_LOCATION="%current%\local"^
      -DGLEW_LOCATION="%current%/local"^
      -DGLFW_LOCATION="%current%/local"^
      -DTBB_LOCATION="%current%/local"^
      -DNO_EXAMPLES=1^
      -DNO_TUTORIALS=1^
      -DNO_REGRESSION=1^
      -DNO_MAYA=1^
      -DNO_PTEX=0^
      -DNO_DOC=1^
      -DNO_OMP=1^
      -DNO_TBB=0^
      -DNO_CUDA=1^
      -DNO_OPENCL=1^
      -DNO_OPENGL=0^
      -DNO_CLEW=0^
       ..\..\OpenSubdiv

rem msbuild OpenSubdiv.sln /t:Build /p:Configuration=Release /p:Platform=x64
echo "Building OpenSubdiv Debug"
cmake --build . --target install --config Debug -- /maxcpucount:8

cd %current%
