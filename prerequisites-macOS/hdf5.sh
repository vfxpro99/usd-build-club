#!/bin/bash

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

if [ ! -f $LOCAL/lib/libhdf5.a ]; then

  mkdir -p prereq
  mkdir -p $LOCAL/lib
  mkdir -p $LOCAL/bin
  mkdir -p $LOCAL/include
  mkdir -p prereq/build/hdf5

  cd prereq
  if [ ! -f hdf5/.git/config ]; then
    git clone git://github.com/vfxpro99/hdf5.git
  fi

  cd hdf5; git pull
  cd ..

  cd build/hdf5

  cmake \
        -DCMAKE_PREFIX_PATH="${LOCAL}" \
        -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
        -DHDF5_BUILD_HL_LIB=1 -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=./hdf5-stage \
        ../../hdf5
  cmake --build . --target install --config Release
  cd ${ROOT}
fi
