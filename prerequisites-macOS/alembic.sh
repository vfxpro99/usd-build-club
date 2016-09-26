#!/bin/bash

mkdir -p prereq
mkdir -p local/lib
mkdir -p local/bin
mkdir -p local/include
mkdir -p build/alembic

ROOT=$(pwd)
cd prereq
if [ ! -f alembic/.git/config ]; then
  git clone git://github.com/alembic/alembic.git
fi
cd alembic; git pull; cd ..

cmake -DUSE_PYILMBASE=1 -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=alembic-stage -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
	-DBOOST_INCLUDEDIR="${ROOT}/local/include" \
	-DBOOST_LIBRARYDIR="${ROOT}/local/lib" \
	-DBoost_INCLUDE_DIR="${ROOT}/local/include" \
	-DBoost_LIBRARY_DIR="${ROOT}/local/lib" \
	-DHDF5_ROOT="${ROOT}/local" \
	-DALEMBIC_PYILMBASE_PYIMATH_LIB="${ROOT}/local/lib/libPyImath.dylib" \
	-DILMBASE_ROOT="${ROOT}/local" \
	-DALEMBIC_PYILMBASE_ROOT="${ROOT}/local" \
	../../alembic

cmake --build . --target install --config Release

cd ${ROOT}
