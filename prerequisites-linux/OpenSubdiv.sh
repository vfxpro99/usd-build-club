#!/bin/bash

if [ -f local/lib/libosdCPU.a ]; then
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
if [ ! -f local/include/opensubdiv/far ]; then
  mkdir -p local/include/opensubdiv/far
fi
if [ ! -f local/include/opensubdiv/hbr ]; then
  mkdir -p local/include/opensubdiv/hbr
fi
if [ ! -f local/include/opensubdiv/osd ]; then
  mkdir -p local/include/opensubdiv/osd
fi
if [ ! -f local/include/opensubdiv/sdc ]; then
  mkdir -p local/include/opensubdiv/sdc
fi
if [ ! -f local/include/opensubdiv/vtr ]; then
  mkdir -p local/include/opensubdiv/vtr
fi

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

make -j 4
make install

cd ${ROOT}

#cp lib/*.a ${ROOT}/local/lib
#cp lib/*.dylib ${ROOT}/local/lib
#cd ..
#cp opensubdiv/*.h ${ROOT}/local/include/opensubdiv
#cp opensubdiv/far/*.h ${ROOT}/local/include/opensubdiv/far
#cp opensubdiv/hbr/*.h ${ROOT}/local/include/opensubdiv/hbr
#cp opensubdiv/osd/*.h ${ROOT}/local/include/opensubdiv/osd
#cp opensubdiv/sdc/*.h ${ROOT}/local/include/opensubdiv/sdc
#cp opensubdiv/vtr/*.h ${ROOT}/local/include/opensubdiv/vtr
#cd ${ROOT}

if [ ! -d "${ROOT}/local/include/opensubdiv3" ]; then
  cp -R ${ROOT}/local/include/opensubdiv ${ROOT}/local/include/opensubdiv3
fi
