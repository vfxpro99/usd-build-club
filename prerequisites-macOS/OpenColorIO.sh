#!/bin/bash
if [ ! -f local/lib/libOpenColorIO.a ]; then

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

  if [ ! -f OpenColorIO/.git/config ]; then
    git clone git://github.com/imageworks/OpenColorIO.git
  else
    cd OpenColorIO; git pull; cd ..
  fi

  mkdir -p build/OpenColorIO
  cd build/OpenColorIO

  cmake \
    -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
    -DCMAKE_INSTALL_NAME_DIR=@rpath \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
    -DBUILD_WITH_INSTALL_RPATH=1 \
    -DCMAKE_VERBOSE_MAKEFILE=OFF \
    ../../OpenColorIO

  make -j 4
  make install

  cd ${ROOT}
fi
