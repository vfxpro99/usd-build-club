
ECHO building hdf5

SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "hdf5/.git/config" ^
git clone https://github.com/vfxpro99/hdf5.git

cd hdf5
git pull
cd ..

if not exist "build\hdf5" ^
mkdir build\hdf5
cd build\hdf5


rem Width with l64 failed with result: -2147483645
rem Width with l failed with result: FAILED_TO_RUN
rem Width with L failed with result: FAILED_TO_RUN
rem Width with q failed with result: FAILED_TO_RUN
rem Width with I64 failed with result: FAILED_TO_RUN
rem Width with ll failed with result: FAILED_TO_RUN

cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local"^
      -DBUILD_SHARED_LIBS=ON^
      -DHDF5_BUILD_HL_LIB=1 -DHDF5_BUILD_CPP_LIB=1 -DHDF5_BUILD_HL_CPP_LIB=1 ^
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=./hdf5-stage^
      ..\..\hdf5

cmake --build . --target install --config Release -- /maxcpucount:8

cd %current%
