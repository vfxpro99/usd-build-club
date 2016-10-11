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

echo "Installing glew to " $LOCAL

if [ ! -f $LOCAL/lib/libGLEW.a ]; then
  cd prereq

  if [ ! -f glew/.git/config ]; then
    git clone https://github.com/nigels-com/glew.git
  fi
  cd glew; git pull; cd ..

  mkdir -p build/glew
  cd build/glew

  make -C ${ROOT}/prereq/glew extensions
  make -C ${ROOT}/prereq/glew all
  make -C ${ROOT}/prereq/glew GLEW_DEST=${LOCAL} install
  cd ${ROOT}

  install_name_tool -id @rpath/libGLEW.2.0.0.dylib $LOCAL/lib/libGLEW.2.0.0.dylib
fi
