#!/bin/bash

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
  chmod 744 build-macos-maya-shared.sh;./build-macos-maya-shared.sh
  cd ${ROOT}
  cp prereq/boost_1_61_0/stage-OSX/lib/* $LOCAL/lib
  cp -R prereq/boost_1_61_0/boost $LOCAL/include
fi
