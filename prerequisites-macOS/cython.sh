#! /bin/sh

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

# early sudo so the build isn't interrupted in the middle waiting for a password
ROOT=$(pwd)
cd prereq

if [ ! -f Cython.tgz ]; then
  curl -L -o Cython.tgz http://cython.org/release/Cython-0.23.4.tar.gz
  tar -zxf Cython.tgz
  cd Cython-0.23.4
  sudo python setup.py install
fi
