#!/bin/bash
mkdir -p prereq
mkdir -p local/lib
mkdir -p local/bin
mkdir -p local/include

ROOT=$(pwd)
cd prereq

if [ ! -f OpenColorIO/.git/config ]; then
  git clone git://github.com/imageworks/OpenColorIO.git
fi
cd OpenColorIO; git pull; cd ..

mkdir -p build/OpenColorIO
cd build/OpenColorIO

cmake \
  -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
  -DCMAKE_INSTALL_NAME_DIR=@rpath \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
  -DBUILD_WITH_INSTALL_RPATH=1 \
  -DCMAKE_VERBOSE_MAKEFILE=OFF \
  ../../OpenColorIO

cmake --build . --target install --config Release
cd ${ROOT}
