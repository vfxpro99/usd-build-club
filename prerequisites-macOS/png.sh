#!/bin/bash
mkdir -p prereq
mkdir -p local/lib
mkdir -p local/bin
mkdir -p local/include

CONFIGURATION="Release"

ROOT=$(pwd)
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
      -DPNG_TESTS=OFF \
      -DCMAKE_PREFIX_PATH=${ROOT}/local \
      -DCMAKE_INSTALL_PREFIX=${ROOT}/local ../../libpng

cmake --build . --target install --config Release

cd ${ROOT}
