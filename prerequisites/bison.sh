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

ROOT=$(pwd)
pushd prereq

if [ ! -d bison-2.4.tar.gz ]; then
  curl http://ftp.gnu.org/gnu/bison/bison-2.4.tar.gz > bison-2.4.tar.gz
fi
if [ ! -f bison-2.4 ]; then
  tar -xf bison-2.4.tar.gz
fi
cd bison-2.4
mkdir build
./configure --prefix ${ROOT}/local
make -j 4;make install
cd ${ROOT}
