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

if [ ! -f local/lib/libGLFW.a ]; then
  GLFW_SCRIPTDIR=`dirname $0`
  source ${GLFW_SCRIPTDIR}/init_local.sh

  cd prereq
  if [ ! -f glfw/.git/config ]; then
    git clone https://github.com/glfw/glfw.git
  fi
  cd glfw; git pull; cd ..

  mkdir -p build/glfw
  cd build/glfw

  cmake -G "Xcode" \
        -DCMAKE_PREFIX_PATH="${LOCAL}" \
        -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
        -DCMAKE_INSTALL_PREFIX="${LOCAL}" ../../glfw

  cmake --build . --target install --config Release

  cd ${ROOT}
fi
