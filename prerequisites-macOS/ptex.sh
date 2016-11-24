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

if [ ! -f local/lib/libPtex.a ]; then
  cd prereq
  if [ ! -f ptex/.git/config ]; then
    git clone git://github.com/wdas/ptex.git
  fi
  cd ptex; git pull; cd ..

  mkdir -p build/ptex
  cd build/ptex

  cmake \
        -DCMAKE_PREFIX_PATH="${LOCAL}" \
        -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
        ../../ptex
  cmake --build . --target install --config Release

  cd ${ROOT}

  install_name_tool -id @rpath/libPtex.dylib ${LOCAL}/lib/libPtex.dylib

fi
