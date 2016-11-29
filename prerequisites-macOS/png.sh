#!/bin/bash

echo building libpng

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

mkdir -p prereq
mkdir -p $LOCAL/lib
mkdir -p $LOCAL/bin
mkdir -p $LOCAL/include

CONFIGURATION="Release"

cd prereq
if [ ! -f libpng/.git/config ]; then
  git clone git://github.com/glennrp/libpng.git
else
  cd libpng; git pull; cd ..
fi

# checkout last known good on OSX

cd libpng
git checkout 830608b
cd ..

mkdir -p build/png; cd build/png
cmake \
      -DCMAKE_PREFIX_PATH="${LOCAL}" \
      -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
      -DPNG_TESTS=OFF \
      ../../libpng

cmake --build . --target install --config Release

cd ${ROOT}
