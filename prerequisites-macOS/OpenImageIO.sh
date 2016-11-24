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
if [ ! -f oiio/.git/config ]; then
  git clone git://github.com/OpenImageIO/oiio.git
fi
cd oiio; git pull; cd ..

mkdir -p build/oiio
cd build/oiio

cmake \
  -DCMAKE_PREFIX_PATH="${LOCAL}" \
  -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
  -DCMAKE_INSTALL_NAME_DIR=@rpath \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
  -DCMAKE_CXX_COMPILER_WORKS=1 \
  -DBUILD_WITH_INSTALL_RPATH=1 \
  -DOPENEXR_CUSTOM_INCLUDE_DIR:STRING="${LOCAL}/include" \
  -DOPENEXR_CUSTOM_LIB_DIR="${LOCAL}/lib" \
  -DBOOST_ROOT="${LOCAL}" \
  -DBOOST_LIBRARYDIR="${LOCAL}/lib" \
  -DBoost_USE_STATIC_LIBS:INT=0 \
  -DBoost_LIBRARY_DIR_RELEASE="${LOCAL}/lib" \
  -DBoost_LIBRARY_DIR_DEBUG="${LOCAL}/lib" \
  -DOCIO_PATH="${LOCAL}" \
  -DPTEX_LOCATION="${LOCAL}" \
  ../../oiio

cmake --build . --target install --config Release

cd ${ROOT}

