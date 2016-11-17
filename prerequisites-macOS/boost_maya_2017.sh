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

  if [ ! -f boost_1_55_0/README.md ]; then
    cp -R /Applications/Autodesk/maya2017/devkit/Alembic/include/AlembicPrivate/boost_1_55_0 boost_1_55_0
  fi

  cd boost_1_55_0
  cp ../boost-build-club/* .
  chmod 744 build-OSX-shared.sh;./build-OSX-shared.sh
  cd ${ROOT}
  cp prereq/boost_1_55_0/stage-OSX/lib/* $LOCAL/lib
  cp -R prereq/boost_1_55_0/boost $LOCAL/include
fi
