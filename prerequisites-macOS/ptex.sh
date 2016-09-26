#!/bin/bash

if [ ! -f local/lib/libPtex.a ]; then

  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)
  cd prereq
  if [ ! -f ptex/.git/config ]; then
    git clone git://github.com/wdas/ptex.git
  fi
  cd ptex; git pull; cd ..

  mkdir -p build/ptex
  cd build/ptex

  cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local ../../ptex
  cmake --build . --target install --config Release

  cd ${ROOT}

  install_name_tool -id @rpath/libPtex.dylib ./local/lib/libPtex.dylib

fi
