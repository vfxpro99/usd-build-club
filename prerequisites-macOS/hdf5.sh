#!/bin/bash
if [ ! -f local/lib/libhdf5.a ]; then

  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include
  mkdir -p build/hdf5

  ROOT=$(pwd)
  cd prereq
  if [ ! -f hdf5/.git/config ]; then
    git clone git://github.com/vfxpro99/hdf5.git
  fi
  cd hdf5; git pull; cd ..

  cd build/hdf5

  cmake -DHDF5_BUILD_HL_LIB=1 -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=./hdf5-stage \
        -DCMAKE_INSTALL_PREFIX=${ROOT}/local ../../hdf5
  cmake --build . --target install --config Release
  cd ${ROOT}
fi
