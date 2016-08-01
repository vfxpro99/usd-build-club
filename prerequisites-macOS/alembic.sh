#! /bin/sh

if [ ! -f local/lib/libAlembic.dylib ]; then
  if [ ! -f prereq ]; then
    mkdir -p prereq
  fi
  if [ ! -f local/lib ]; then
    mkdir -p local/lib
  fi
  if [ ! -f local/bin ]; then
    mkdir -p local/bin
  fi
  if [ ! -f local/include ]; then
    mkdir -p local/include
  fi

  ROOT=$(pwd)
  cd prereq
  if [ ! -f alembic/.git/config ]; then
    git clone git://github.com/alembic/alembic.git
  else
    cd alembic; git pull; cd ..
  fi
  cd alembic

  mkdir alembic_build
  cd alembic_build

  cmake -DUSE_PYILMBASE=1 -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=alembic-stage -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
  	-DBOOST_INCLUDEDIR="${ROOT}/local/include" \
  	-DBOOST_LIBRARYDIR="${ROOT}/local/lib" \
  	-DBoost_INCLUDE_DIR="${ROOT}/local/include" \
  	-DBoost_LIBRARY_DIR="${ROOT}/local/lib" \
  	-DHDF5_ROOT="${ROOT}/local" \
  	-DALEMBIC_PYILMBASE_PYIMATH_LIB="${ROOT}/local/lib/libPyImath.dylib" \
  	-DILMBASE_ROOT="${ROOT}/local" \
  	-DALEMBIC_PYILMBASE_ROOT="${ROOT}/local" \
  	..

  make -j 4
  make install
  cd ${ROOT}
fi
