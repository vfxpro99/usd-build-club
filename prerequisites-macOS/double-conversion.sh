#!/bin/bash
ROOT=$(pwd)

LOCAL=${ROOT}/local

if [ $# > 1 ]; then
  LOCAL=$1
fi

mkdir -p prereq
mkdir -p $LOCAL/lib
mkdir -p $LOCAL/bin
mkdir -p $LOCAL/include/double-conversion

if [ ! -f $LOCAL/lib/libdouble-conversion.a ]; then

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
  cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${LOCAL} ../../double-conversion
  cmake --build . --target install --config Release
  cd ${ROOT}
fi
