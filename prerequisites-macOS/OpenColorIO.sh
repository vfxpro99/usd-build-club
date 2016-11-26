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
  -DCMAKE_PREFIX_PATH="${LOCAL}" \
  -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
  -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_INSTALL_NAME_DIR=@rpath \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
  -DCMAKE_VERBOSE_MAKEFILE=OFF \
  -DEXTERNAL_INCLUDE_DIRS="${LOCAL}/include" \
  ../../OpenColorIO

cmake --build . --target install --config Release
cd ${ROOT}
