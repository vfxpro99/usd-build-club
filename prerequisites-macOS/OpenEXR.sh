#!/bin/bash

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

echo 'Installing OpenEXR to ' $LOCAL

if [ ! -f $LOCAL/lib/libHalf.12.0.0.dylib ]; then

  mkdir -p prereq
  mkdir -p $LOCAL/lib
  mkdir -p $LOCAL/bin
  mkdir -p $LOCAL/include

  cd prereq
  if [ ! -f openexr/.git/config ]; then
    git clone git://github.com/openexr/openexr.git
  fi
  cd openexr; git pull; cd ..

  if [ -f build/ilmbase ]; then
    rm -rf build/ilmbase
  fi
  mkdir -p build/ilmbase

  if [ -f build/openexr ]; then
    rm -rf build/openexr
  fi
  mkdir -p build/openexr

  cd build/ilmbase

  cmake \
        -DCMAKE_PREFIX_PATH="${LOCAL}" \
        -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
        -DCMAKE_INSTALL_NAME_DIR=@rpath \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
        -DBUILD_WITH_INSTALL_RPATH=1 \
        ${ROOT}/prereq/openexr/IlmBase
  cmake --build . --target install --config Release

  cd ../openexr

  cmake \
        -DCMAKE_PREFIX_PATH="${LOCAL}" \
        -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
        -DCMAKE_INSTALL_NAME_DIR=@rpath \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
        -DBUILD_WITH_INSTALL_RPATH=1 \
        -DILMBASE_PACKAGE_PREFIX="${LOCAL}" \
        ${ROOT}/prereq/openexr/OpenEXR
  cmake --build . --target install --config Release

  cd ${ROOT}

fi
