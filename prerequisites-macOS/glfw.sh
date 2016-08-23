#!/bin/bash

if [ ! -f local/lib/libGLFW.a ]; then
  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)

  GLFW_SCRIPTDIR=`dirname $0`
  source ${GLFW_SCRIPTDIR}/init_local.sh

  cd prereq
  if [ ! -f glfw/.git/config ]; then
    git clone https://github.com/glfw/glfw.git
  fi
  cd glfw; git pull; cd ..

  mkdir -p build/glfw
  cd build/glfw

  cmake -G "Visual Studio 14 2015 Win64" \
        -DCMAKE_PREFIX_PATH="${ROOT}/local" \
        -DCMAKE_INSTALL_PREFIX="${ROOT}/local" ../../glfw

  cmake --build . --target install --config Release

  cd ${ROOT}
fi
