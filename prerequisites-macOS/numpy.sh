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

if [ ! -f local/include/numpy/_numpyconfig.h ]; then
  cd prereq

  if [ ! -f numpy/.git/config ]; then
    git clone git://github.com/numpy/numpy.git
  fi
  cd numpy; git pull

  python setup.py build
  python setup.py install
  cp -R numpy/core/include/numpy ${LOCAL}/include
  cp -R build/src.macosx-*-intel-2.7/numpy/core/include/numpy ${LOCAL}/include
  cd ${ROOT}
fi
