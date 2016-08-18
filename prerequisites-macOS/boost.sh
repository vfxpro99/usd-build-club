#!/bin/bash

if [ ! -f local/lib/libboost_python.dylib ]; then
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
  cd prereq
  if [ ! -f boost-build-club/.git/config ]; then
     git clone https://github.com/vfxpro99/boost-build-club.git
  else
    cd boost-build-club; git pull; cd ..
  fi

  curl -L -o boost.tgz http://downloads.sourceforge.net/sourceforge/boost/boost_1_60_0.tar.gz;
  # $? is the result of the most recent command
  rc=$?
  if [ $rc -eq 0 ]; then
    tar -zxf boost.tgz
    rc=$?
    if [ $rc -ne 0 ]; then
      echo Failed to retrieve boost archive
      exit 1
    fi

    cd boost_1_60_0
    cp ../boost-build-club/* .
    chmod 744 build-OSX-shared.sh;./build-OSX-shared.sh
    cp stage-OSX/lib/* ${ROOT}/local/lib
    cp -R boost ${ROOT}/local/include/boost
    cd ${ROOT}
  else
    echo Failed to retrieve boost archive.
    exit $rc
  fi
fi
