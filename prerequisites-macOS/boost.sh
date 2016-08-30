#!/bin/bash

if [ ! -f local/lib/libboost_python.dylib ]; then
  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)
  cd prereq
  if [ ! -f boost-build-club/.git/config ]; then
     git clone https://github.com/vfxpro99/boost-build-club.git
  fi
  cd boost-build-club; git pull; cd ..

  if [ ! -f boost.tgz ]; then
    curl -L -o boost.tgz http://downloads.sourceforge.net/sourceforge/boost/boost_1_61_0.tar.gz;
    rc=$?
    if [ $rc -ne 0 ]; then
      echo Failed to retrieve boost archive
      exit 1
    fi
  fi

  if [ ! -f boost_1_61/README.md ]; then
    tar -zxf boost.tgz
    rc=$?
    if [ $rc -ne 0 ]; then
      echo Failed to extract boost archive
      exit 1
    fi
  fi

  cd boost_1_61_0
  cp ../boost-build-club/* .
  chmod 744 build-OSX-shared.sh;./build-OSX-shared.sh
  cp stage-OSX/lib/* ${ROOT}/local/lib
  cp -R boost ${ROOT}/local/include/boost
  cd ${ROOT}
fi
