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
cd OpenColorIO
git pull
git checkout 2b12063
cd ..

mkdir -p build/OpenColorIO
cd build/OpenColorIO

cmake \
  -DCMAKE_PREFIX_PATH="${LOCAL}" \
  -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
  -DOCIO_USE_BOOST_PTR=1 \
  -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_INSTALL_NAME_DIR=@rpath \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
  -DCMAKE_VERBOSE_MAKEFILE=OFF \
  -DOCIO_BUILD_APPS=OFF \
  -DOCIO_BUILD_DOCS=OFF \
  -DOCIO_BUILD_TESTS=OFF \
  -DOCIO_BUILD_JNIGLUE=OFF \
  -DEXTERNAL_INCLUDE_DIRS="${LOCAL}/include" \
  ../../OpenColorIO

cmake --build . --target install --config Release
cd ${ROOT}
