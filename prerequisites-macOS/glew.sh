#!/bin/bash

if [ ! -f local/lib/libGLEW.a ]; then
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
  if [ ! -f glew/.git/config ]; then
    git clone https://github.com/nigels-com/glew.git
  else
    cd glew; git pull; cd ..
  fi
  mkdir glew_build
  cd glew_build
  make -C ${ROOT}/prereq/glew extensions
  make -C ${ROOT}/prereq/glew all
  make -C ${ROOT}/prereq/glew GLEW_DEST=${ROOT}/local install
  cd ${ROOT}

  install_name_tool -id @rpath/libGLEW.2.0.0.dylib ./local/lib/libGLEW.2.0.0.dylib
fi
