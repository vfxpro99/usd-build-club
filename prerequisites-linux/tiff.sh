#!/bin/bash

if [ ! -f local/lib/libtiff.a ]; then

  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)
  cd prereq

  if [ ! -f libtiff/.git/config ]; then
    git clone https://github.com/vadz/libtiff
  else
    cd libtiff; git pull; cd ..
  fi

  cd libtiff
  ./configure --disable-dependency-tracking --prefix=${ROOT}/local --enable-cxx=0
  make -j 4
  make install

  cd ${ROOT}

  install_name_tool -id @rpath/libtiff.5.dylib ./local/lib/libtiff.5.dylib

fi
