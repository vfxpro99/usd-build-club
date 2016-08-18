#!/bin/bash
if [ -f local/lib/libHalf.12.0.0.dylib ]; then
  exit 0
fi

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
if [ ! -f openexr/.git/config ]; then
  git clone git://github.com/openexr/openexr.git
else
  cd openexr; git pull; cd ..
fi

if [ -f build/ilmbase ]; then
  rm -rf build/ilmbase
fi
mkdir -p build/ilmbase

if [ -f build/openexr ]; then
  rm -rf build/openexr
fi
mkdir -p build/openexr

cd build/ilmbase

cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
      -DCMAKE_INSTALL_NAME_DIR=@rpath \
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
      -DBUILD_WITH_INSTALL_RPATH=1 \
      ${ROOT}/prereq/openexr/IlmBase
make -j 4
make install

cd ../openexr

cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
      -DCMAKE_INSTALL_NAME_DIR=@rpath \
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
      -DBUILD_WITH_INSTALL_RPATH=1 \
      -DILMBASE_PACKAGE_PREFIX=${ROOT}/local \
      ${ROOT}/prereq/openexr/OpenEXR
make -j 4
make install

cd ${ROOT}
