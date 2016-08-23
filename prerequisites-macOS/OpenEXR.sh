#!/bin/bash
if [ -f local/lib/libHalf.12.0.0.dylib ]; then
  exit 0
fi

mkdir -p prereq
mkdir -p local/lib
mkdir -p local/bin
mkdir -p local/include

ROOT=$(pwd)
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

cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
      -DCMAKE_INSTALL_NAME_DIR=@rpath \
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
      -DBUILD_WITH_INSTALL_RPATH=1 \
      ${ROOT}/prereq/openexr/IlmBase
cmake --build . --target install --config Release

cd ../openexr

cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
      -DCMAKE_INSTALL_NAME_DIR=@rpath \
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
      -DBUILD_WITH_INSTALL_RPATH=1 \
      -DILMBASE_PACKAGE_PREFIX=${ROOT}/local \
      ${ROOT}/prereq/openexr/OpenEXR
cmake --build . --target install --config Release

cd ${ROOT}
