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

if [ ! -f local/lib/libtiff.a ]; then
  cd prereq

  if [ ! -f libtiff/.git/config ]; then
    git clone https://github.com/vadz/libtiff
  fi
  cd libtiff
  git pull

  ./configure --disable-dependency-tracking --prefix=${LOCAL} --enable-cxx=0
  make -j 4
  make install

  cd ${ROOT}

  install_name_tool -id @rpath/libtiff.5.dylib $LOCAL/lib/libtiff.5.dylib

fi
