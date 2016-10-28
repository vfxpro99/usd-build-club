#!/bin/bash

ROOT=$(pwd)

LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

mkdir -p prereq
mkdir -p $LOCAL/lib
mkdir -p $LOCAL/bin
mkdir -p $LOCAL/include
mkdir -p prereq/build/alembic

echo "Retrieving Alembic 1.6.1 for compatibility"

cd prereq
if [ ! -f alembic/.git/config ]; then
  git clone git://github.com/alembic/alembic.git
fi
cd alembic; git pull;
# todo - have a command line switch to allow top of tree
git checkout a3aa758
cd ..

cd build/alembic

cmake -DUSE_PYILMBASE=1 -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=alembic-stage \
    -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
	-DBOOST_INCLUDEDIR="${LOCAL}/include" \
	-DBOOST_LIBRARYDIR="${LOCAL}/lib" \
	-DBoost_INCLUDE_DIR="${LOCAL}/include" \
	-DBoost_LIBRARY_DIR="${LOCAL}/lib" \
	-DHDF5_ROOT="${LOCAL}" \
	-DALEMBIC_PYILMBASE_PYIMATH_LIB="${LOCAL}/lib/libPyImath.dylib" \
	-DILMBASE_ROOT="${LOCAL}" \
	-DALEMBIC_PYILMBASE_ROOT="${LOCAL}" \
	../../alembic

cmake --build . --target install --config Release

cd ${ROOT}
