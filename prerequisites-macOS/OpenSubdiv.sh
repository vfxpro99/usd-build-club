#! /bin/sh

if [ ! -f local/lib/libosdCPU.a ]; then

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

  cd OpenSubdiv
  cp ./../../${SCRIPTDIR}/FindPTex.cmake cmake/FindPtex.cmake

  mkdir build;cd build
  # temporary: suppress ptex until OSD is updated on github
  cmake -DNOPTEX=1 -DCMAKE_INSTALL_PREFIX=${ROOT}/local -DGLEW_LOCATION=${ROOT}/local ..
  make -j 4
  cp lib/*.a ${ROOT}/local/lib
  cp lib/*.dylib ${ROOT}/local/lib
  cd ..
  cp opensubdiv/*.h ${ROOT}/local/include/opensubdiv
  cp opensubdiv/far/*.h ${ROOT}/local/include/opensubdiv/far
  cp opensubdiv/hbr/*.h ${ROOT}/local/include/opensubdiv/hbr
  cp opensubdiv/osd/*.h ${ROOT}/local/include/opensubdiv/osd
  cp opensubdiv/sdc/*.h ${ROOT}/local/include/opensubdiv/sdc
  cp opensubdiv/vtr/*.h ${ROOT}/local/include/opensubdiv/vtr
  cd ${ROOT}

  if [ ! -d "${ROOT}/local/include/opensubdiv3" ]; then
    cp -R ${ROOT}/local/include/opensubdiv ${ROOT}/local/include/opensubdiv3
  fi
fi
