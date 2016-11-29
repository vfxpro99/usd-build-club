#!/bin/bash

echo building OpenSubdiv

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

mkdir -p prereq
mkdir -p $LOCAL/lib
mkdir -p $LOCAL/bin
mkdir -p $LOCAL/include/opensubdiv/far
mkdir -p $LOCAL/include/opensubdiv/hbr
mkdir -p $LOCAL/include/opensubdiv/osd
mkdir -p $LOCAL/include/opensubdiv/sdc
mkdir -p $LOCAL/include/opensubdiv/vtr

if [ ! -f local/lib/libosdCPU.a ]; then

  SCRIPTDIR=`dirname $0`

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

  cmake \
        -DCMAKE_PREFIX_PATH="${LOCAL}" \
        -DCMAKE_INSTALL_PREFIX="${LOCAL}" \
        -DGLEW_LOCATION="${LOCAL}" \
        -DGLFW_LOCATION="${LOCAL}" \
        -DCMAKE_INSTALL_NAME_DIR=@rpath \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
        -DBUILD_WITH_INSTALL_RPATH=1 \
        -DNO_OMP=1 \
        ../../OpenSubdiv

  cmake --build . --target install --config Release

  cd ${ROOT}

  if [ ! -d "${LOCAL}/include/opensubdiv3" ]; then
    cp -R ${LOCAL}/include/opensubdiv ${LOCAL}/include/opensubdiv3
  fi

fi
