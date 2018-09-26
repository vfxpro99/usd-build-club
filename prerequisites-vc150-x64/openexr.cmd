
ECHO building OpenEXR

echo zlib is a prerequisite for OpenEXR

SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

IF NOT EXIST "openexr\README" ^
git clone git://github.com/openexr/openexr.git

cd openexr
git pull
cd ..

if not exist "build\openexr" mkdir build\openexr
cd build\openexr
cmake -G "Visual Studio 15 2017 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local"^
      ..\..\openexr

cmake --build . --target install --config Release -- /maxcpucount:8

cd %current%

