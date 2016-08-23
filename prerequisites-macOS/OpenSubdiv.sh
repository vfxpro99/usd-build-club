#!/bin/bash

if [ -f local/lib/libosdCPU.a ]; then
  exit 0
fi

mkdir -p prereq
mkdir -p local/lib
mkdir -p local/bin
mkdir -p local/include/opensubdiv/far
mkdir -p local/include/opensubdiv/hbr
mkdir -p local/include/opensubdiv/osd
mkdir -p local/include/opensubdiv/sdc
mkdir -p local/include/opensubdiv/vtr

SCRIPTDIR=`dirname $0`

ROOT=$(pwd)
cd prereq
if [ ! -f OpenSubdiv/.git/config ]; then
  git clone git://github.com/PixarAnimationStudios/OpenSubdiv.git
else
  cd OpenSubdiv; git pull; cd ..
fi

if [ -f build/OpenSubdiv ]; then
  rm -rf build/OpenSubdiv
fi
mkdir -p build/OpenSubdiv

cd OpenSubdiv
cp ./../../${SCRIPTDIR}/FindPTex.cmake cmake/FindPtex.cmake
cd ..

cd build/OpenSubdiv

cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
      -DGLEW_LOCATION=${ROOT}/local \
      -DCMAKE_INSTALL_NAME_DIR=@rpath \
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
      -DBUILD_WITH_INSTALL_RPATH=1 \
      ../../OpenSubdiv

cmake --build . --target install --config Release

cd ${ROOT}

if [ ! -d "${ROOT}/local/include/opensubdiv3" ]; then
  cp -R ${ROOT}/local/include/opensubdiv ${ROOT}/local/include/opensubdiv3
fi
