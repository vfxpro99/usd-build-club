#!/bin/bash

LOCAL=local

# this directory contains lib/darwin-9.x.universal/python
BLENDER_BUILD=/path/to/my/blenderbuild
echo "fix the line above and delete this line and the exit"
exit 1


if [ $# -ge 1 ]; then
  LOCAL=$1
fi

if [ ! -f prereq/boost_1_51_0/stage/lib/libboost_python.a ]; then
  mkdir -p prereq
  mkdir -p $LOCAL/lib
  mkdir -p $LOCAL/bin
  mkdir -p $LOCAL/include

  ROOT=$(pwd)
  cd prereq

  if [ ! -f boost-151.tgz ]; then
    curl -L -o boost-151.tgz http://downloads.sourceforge.net/sourceforge/boost/boost_1_51_0.tar.gz;
    rc=$?
    if [ $rc -ne 0 ]; then
      echo Failed to retrieve boost archive
      exit 1
    fi
  fi

  if [ ! -f boost_1_51_0/README.md ]; then
    tar -zxf boost-151.tgz
    rc=$?
    if [ $rc -ne 0 ]; then
      echo Failed to extract boost archive
      exit 1
    fi
  fi

  cd boost_1_51_0
  ./bootstrap.sh \
    --with-python-version=3.5 \
    --with-python-root=$BLENDER_BUILD/lib/darwin-9.x.universal/python \
    --with-python=$BLENDER_BUILD/lib/darwin-9.x.universal/python/bin/python3.5m

  ./bjam -j8 variant=release cxxflags='-stdlib=libstdc++' link=static \
         threading=multi architecture=x86 address-model=32_64 \
         --macosx-version=10.9 --macosx-version-min=10.6 \
         --with-python \
         stage -a
         
#          --with-filesystem --with-thread --with-regex --with-system \
#          --with-date_time --with-wave --with-program_options --with-serialization --with-locale stage -a

    cd ${ROOT}

    cp prereq/boost_1_51_0/stage/lib/libboost_python.a $BLENDER_BUILD/lib/darwin-9.x.universal/boost/lib/
fi
