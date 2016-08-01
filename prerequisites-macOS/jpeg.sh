#! /bin/sh

if [ ! -f local/lib/libjpeg.a ]; then

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
  if [ ! -f local/man/man1 ]; then
    mkdir -p local/man/man1
  fi

  ROOT=$(pwd)
  cd prereq
  curl http://www.ijg.org/files/jpegsrc.v6b.tar.gz > jpeg.tgz
  tar -xf jpeg.tgz
  cd jpeg-6b
  ./configure --disable-dependency-tracking --prefix=${ROOT}/local
  make install
  make install-lib

  cd ${ROOT}
fi
