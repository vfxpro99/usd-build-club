#!/bin/bash

if [ ! -f local/lib/libGLEW.a ]; then
  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)
  cd prereq

  if [ ! -f glew/.git/config ]; then
    git clone https://github.com/nigels-com/glew.git
  fi
  cd glew; git pull; cd ..

  mkdir -p build/glew
  cd build/glew

  make -C ${ROOT}/prereq/glew extensions
  make -C ${ROOT}/prereq/glew all
  make -C ${ROOT}/prereq/glew GLEW_DEST=${ROOT}/local install
  cd ${ROOT}

  install_name_tool -id @rpath/libGLEW.2.0.0.dylib ./local/lib/libGLEW.2.0.0.dylib
fi
