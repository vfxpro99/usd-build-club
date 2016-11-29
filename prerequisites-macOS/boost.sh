#!/bin/bash

echo building boost 1.62

LOCAL=local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

if [ ! -f $LOCAL/lib/libboost_python.dylib ]; then
  mkdir -p prereq
  mkdir -p $LOCAL/lib
  mkdir -p $LOCAL/bin
  mkdir -p $LOCAL/include

  ROOT=$(pwd)
  cd prereq
  if [ ! -f boost-build-club/.git/config ]; then
     git clone https://github.com/vfxpro99/boost-build-club.git
  fi
  cd boost-build-club; git pull; cd ..

  if [ ! -f boost.tgz ]; then
    echo retrieving boost 1.62 archive

    curl -L -o boost.tgz http://downloads.sourceforge.net/sourceforge/boost/boost_1_62_0.tar.gz;
    rc=$?
    if [ $rc -ne 0 ]; then
      echo Failed to retrieve boost archive
      exit 1
    fi
  fi

  if [ ! -f boost_1_62/README.md ]; then
    echo extracting boost archive
    tar -zxf boost.tgz
    rc=$?
    if [ $rc -ne 0 ]; then
      echo Failed to extract boost archive
      exit 1
    fi
  fi

  cd boost_1_62_0
  cp ../boost-build-club/* .
  chmod 744 build-OSX-shared.sh

  echo building boost 1.62

  ./build-OSX-shared.sh
  cd ${ROOT}
  cp prereq/boost_1_62_0/stage-OSX/lib/* $LOCAL/lib
  cp -R prereq/boost_1_62_0/boost $LOCAL/include
fi
