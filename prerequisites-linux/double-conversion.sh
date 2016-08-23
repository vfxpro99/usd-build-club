#!/bin/bash
if [ ! -f local/lib/libdouble-conversion.a ]; then

  if [ ! -f prereq ]; then
    mkdir -p prereq
  fi
  if [ ! -f local/lib ]; then
    mkdir -p local/lib
  fi
  if [ ! -f local/bin ]; then
    mkdir -p local/bin
  fi
  if [ ! -f local/include/double-conversion ]; then
    mkdir -p local/include/double-conversion
  fi

  ROOT=$(pwd)
  cd prereq
  if [ ! -f double-conversion/.git/config ]; then
    # https://github.com/google/double-conversion/issues/33
    # note: Top of tree is broken, this version works
    git clone -o 0e47d5ac324c1d012e0dbbdf4f5d78d5fc3ad3cb https://github.com/google/double-conversion.git
  fi

  if [ -f build/double-conversion ]; then
    rm -rf build/double-conversion
  fi

  mkdir -p build/double-conversion
  cd build/double-conversion

  # building with shared libraries off because the rpath generated is wrong
  cmake -DCMAKE_CXX_COMPILER=gcc -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${ROOT}/local ../../double-conversion
  make -j 4
  make install
  cd ${ROOT}
fi
