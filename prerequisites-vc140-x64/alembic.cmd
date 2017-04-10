ECHO Building Alembic

SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

echo "Retrieving Alembic at version 1.6.1 for compatibility"

if not exist "alembic/.git/config" ^
git clone git://github.com/alembic/alembic.git

cd alembic
git pull
rem todo - have a command line switch to allow top of tree
git checkout a3aa758
cd ..

if not exist "build\alembic" ^
mkdir build\alembic
cd build\alembic

cmake  -G "Visual Studio 14 2015 Win64"^
    -DCMAKE_PREFIX_PATH="%current%\local"^
    -DCMAKE_INSTALL_PREFIX="%current%\local"^
    -DUSE_PYILMBASE=1 -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=alembic-stage^
	-DBOOST_INCLUDEDIR="%current%\local\include"^
	-DBOOST_LIBRARYDIR="%current%\local\lib"^
	-DBoost_INCLUDE_DIR="%current%\local\include"^
	-DBoost_LIBRARY_DIR="%current%\local\lib"^
    -DUSE_HDF5=OFF^
	-DUSE_TESTS=OFF -DUSE_EXAMPLES=OFF^
	-DALEMBIC_PYILMBASE_PYIMATH_LIB="%current%\local\lib\libPyImath.lib"^
	-DILMBASE_ROOT="%current%\local"^
	-DALEMBIC_PYILMBASE_ROOT="%current%\local"^
	../../alembic

cmake --build . --target install --config Release -- /maxcpucount:8

cd %current%
