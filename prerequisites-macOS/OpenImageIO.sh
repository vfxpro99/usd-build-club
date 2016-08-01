#! /bin/sh

if [ ! -f local/lib/libOpenImageIO.a ]; then
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
  if [ ! -f oiio/.git/config ]; then
    git clone git://github.com/OpenImageIO/oiio.git
  else
    cd oiio; git pull; cd ..
  fi
  cd oiio
  mkdir build;cd build
  echo $(pwd)
  cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
  -DCMAKE_CXX_COMPILER_WORKS=1 \
  -DOPENEXR_CUSTOM_INCLUDE_DIR:STRING=${ROOT}/local/include \
  -DOPENEXR_CUSTOM_LIB_DIR=${ROOT}/local/lib \
  -DBOOST_ROOT=${ROOT}/local \
  -DBOOST_LIBRARYDIR=${ROOT}/local/lib \
  -DBoost_USE_STATIC_LIBS:INT=1 \
  -DBoost_LIBRARY_DIR_RELEASE=${ROOT}/local/lib \
  -DBoost_LIBRARY_DIR_DEBUG=${ROOT}/local/lib \
  -DJPEG_PATH=${ROOT}/local -DUSE_JPEGTURBO=0 \
  -DOCIO_PATH=${ROOT}/local \
  -DPTEX_LOCATION=${ROOT}/local \
  ..
  make -j 4;
  make install

  cd ${ROOT}

  install_name_tool -change libPtex.dylib @rpath/libPtex.dylib ${ROOT}/local/lib/libOpenImageIO.1.7.3.dylib
  install_name_tool -change libOpenColorIO.1.dylib @rpath/libOpenColorIO.1.0.9.dylib local/lib/libOpenImageIO.1.7.3.dylib

fi
