#!/bin/bash

if [ ! -f local/lib/libjpeg.a ]; then
  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)
  cd prereq
  if [ ! -f jpeg.tgz ]; then
    curl http://www.ijg.org/files/jpegsrc.v6b.tar.gz > jpeg.tgz
  fi
  if [ ! -f jpeg-6b/README ]; then
    tar -xf jpeg.tgz
  fi
  cd jpeg-6b
  ./configure --disable-dependency-tracking --prefix=${ROOT}/local
  make install
  make install-lib

  cd ${ROOT}
fi
