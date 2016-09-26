#!/bin/bash

if [ ! -f Cython.tgz ]; then
  ROOT=$(pwd)
  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  cd prereq

  curl -L -o Cython.tgz http://cython.org/release/Cython-0.23.4.tar.gz
  tar -zxf Cython.tgz
  cd Cython-0.23.4
  sudo python setup.py install
fi
