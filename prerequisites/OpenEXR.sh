#! /bin/sh
if [ ! -f local/lib/libHalf.12.0.0.dylib ]; then

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
  mkdir ilmbase_build
  cd ilmbase_build
  cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local ${ROOT}/prereq/openexr/IlmBase
  make -j 4
  make install
  cd ..
  mkdir openexr_build
  cd openexr_build
  cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local -DILMBASE_PACKAGE_PREFIX=${ROOT}/local ${ROOT}/prereq/openexr/OpenEXR
  make -j 4
  make install
  cd ${ROOT}

  if [ ! -f "${ROOT}/local/lib/libIex.dylib" ]; then
    ln -s -f ${ROOT}/local/libIex-2_2.12.0.0.dylib ${ROOT}/local/lib/libIex.dylib
  fi
  if [ ! -f "${ROOT}/local/lib/libIexMath.dylib" ]; then
    ln -s -f ${ROOT}/local/lib/libIexMath-2_2.12.0.0.dylib ${ROOT}/local/lib/libIexMath.dylib
  fi
  if [ ! -f "${ROOT}/local/lib/libIlmImf.dylib" ]; then
    ln -s -f ${ROOT}/local/lib/libIlmImf-2_2.12.0.0.dylib ${ROOT}/local/lib/libIlmImf.dylib
  fi
  if [ ! -f "${ROOT}/local/lib/libIlmImfUtil.dylib" ]; then
    ln -s -f ${ROOT}/local/lib/libIlmImfUtil-2_2.12.0.0.dylib ${ROOT}/local/lib/libIlmImfUtil.dylib
  fi
  if [ ! -f "${ROOT}/local/lib/libIlmThread.dylib" ]; then
    ln -s -f ${ROOT}/local/lib/libIlmThread-2_2.12.0.0.dylib ${ROOT}/local/lib/libIlmThread.dylib
  fi
  if [ ! -f "${ROOT}/local/lib/libImath.dylib" ]; then
    ln -s -f ${ROOT}/local/lib/libImath-2_2.12.0.0.dylib ${ROOT}/local/lib/libImath.dylib
  fi
fi
