#!/bin/bash

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

mkdir -p prereq
mkdir -p $LOCAL/lib
mkdir -p $LOCAL/bin
mkdir -p $LOCAL/include

cd prereq
if [ ! -f tbb44.tgz ]; then
  curl -L -o tbb44.tgz https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20151115oss_src.tgz
fi
if [ ! -f tbb44_20151115oss/README ]; then
  tar -zxf tbb44.tgz
fi
cd tbb44_20151115oss

make -j 4
cd ${ROOT}
# only copy libtbb because the malloc libs are very problematic
cp prereq/tbb44_20151115oss/build/macos_intel64_*_release/libtbb.dylib $LOCAL/lib
cp -R prereq/tbb44_20151115oss/include/serial $LOCAL/include/serial
cp -R prereq/tbb44_20151115oss/include/tbb $LOCAL/include/tbb
cd local/lib
install_name_tool -id @rpath/libtbb.dylib $LOCAL/lib/libtbb.dylib
#install_name_tool -id @rpath/libtbbmalloc.dylib $LOCAL/lib/libtbbmalloc.dylib
#install_name_tool -id @rpath/libtbbmalloc_proxy.dylib $LOCAL/lib/libtbbmalloc_proxy.dylib
cd ${ROOT}
