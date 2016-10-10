#!/bin/bash

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

mkdir -p prereq
mkdir -p $LOCAL/lib
mkdir -p $LOCAL/bin
mkdir -p $LOCAL/include

if [ ! -f $LOCAL/lib/libjpeg.a ]; then
  cd prereq
  if [ ! -f jpeg.tgz ]; then
    curl http://www.ijg.org/files/jpegsrc.v6b.tar.gz > jpeg.tgz
  fi
  if [ ! -f jpeg-6b/README ]; then
    tar -xf jpeg.tgz
  fi
  cd jpeg-6b
  ./configure --disable-dependency-tracking --prefix=${LOCAL}
  make install
  make install-lib

  cd ${ROOT}
fi
