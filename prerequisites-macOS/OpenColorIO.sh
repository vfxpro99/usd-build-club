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

cd prereq

if [ ! -f OpenColorIO/.git/config ]; then
  git clone git://github.com/imageworks/OpenColorIO.git
fi
cd OpenColorIO; git pull; cd ..

mkdir -p build/OpenColorIO
cd build/OpenColorIO

cmake \
  -DCMAKE_INSTALL_PREFIX=${LOCAL} \
  -DCMAKE_INSTALL_NAME_DIR=@rpath \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
  -DBUILD_WITH_INSTALL_RPATH=1 \
  -DCMAKE_VERBOSE_MAKEFILE=OFF \
  ../../OpenColorIO

cmake --build . --target install --config Release
cd ${ROOT}
