#!/bin/bash

if [ ! -f local/lib/libOpenImageIO.dylib ]; then
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
  if [ ! -f oiio/.git/config ]; then
    git clone git://github.com/OpenImageIO/oiio.git
  else
    cd oiio; git pull; cd ..
  fi

  mkdir -p build/oiio
  cd build/oiio

  cmake \
    -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
    -DCMAKE_INSTALL_NAME_DIR=@rpath \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
    -DCMAKE_CXX_COMPILER_WORKS=1 \
    -DBUILD_WITH_INSTALL_RPATH=1 \
    -DOPENEXR_CUSTOM_INCLUDE_DIR:STRING=${ROOT}/local/include \
    -DOPENEXR_CUSTOM_LIB_DIR=${ROOT}/local/lib \
    -DBOOST_ROOT=${ROOT}/local \
    -DBOOST_LIBRARYDIR=${ROOT}/local/lib \
    -DBoost_USE_STATIC_LIBS:INT=0 \
    -DBoost_LIBRARY_DIR_RELEASE=${ROOT}/local/lib \
    -DBoost_LIBRARY_DIR_DEBUG=${ROOT}/local/lib \
    -DOCIO_PATH=${ROOT}/local \
    -DPTEX_LOCATION=${ROOT}/local \
    ../../oiio

  make -j 4;
  make install

  cd ${ROOT}

fi
