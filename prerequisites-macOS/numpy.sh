#!/bin/bash

if [ ! -f local/include/numpy/_numpyconfig.h ]; then
  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)
  cd prereq

  if [ ! -f numpy/.git/config ]; then
    git clone git://github.com/numpy/numpy.git
  fi
  cd numpy; git pull

  python setup.py build
  python setup.py install
  cp -R numpy/core/include/numpy ${ROOT}/local/include
  cp -R build/src.macosx-*-intel-2.7/numpy/core/include/numpy ${ROOT}/local/include
  cd ${ROOT}
fi
