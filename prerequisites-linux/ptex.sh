#!/bin/bash

if [ ! -f local/lib/libPtex.a ]; then

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
  if [ ! -f ptex/.git/config ]; then
    git clone git://github.com/wdas/ptex.git
  else
    cd ptex; git pull; cd ..
  fi
  cd ptex;mkdir build;cd build
  cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local ..
  make -j 4
  make install

  cd ${ROOT}

  install_name_tool -id @rpath/libPtex.dylib ./local/lib/libPtex.dylib

fi
