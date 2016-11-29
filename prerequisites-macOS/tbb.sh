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

echo "Building TBB from 2017 Update 1"

cd prereq
if [ ! -f tbb44.tgz ]; then
  curl -L -o tbb44.tgz https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb2017_20160916oss_src.tgz
fi

if [ ! -f tbb2017_20160916oss/README ]; then
  tar -zxf tbb44.tgz
fi
cd tbb2017_20160916oss

make -j 4
cd ${ROOT}
# not copying libtbbmalloc_proxy on purpose.
cp prereq/tbb2017_20160916oss/build/macos_intel64_*_release/libtbb.dylib $LOCAL/lib
cp prereq/tbb2017_20160916oss/build/macos_intel64_*_release/libtbbmalloc.dylib $LOCAL/lib
cp -R prereq/tbb2017_20160916oss/include/serial $LOCAL/include/serial
cp -R prereq/tbb2017_20160916oss/include/tbb $LOCAL/include/tbb
cd local/lib
install_name_tool -id @rpath/libtbb.dylib $LOCAL/lib/libtbb.dylib
install_name_tool -id @rpath/libtbbmalloc.dylib $LOCAL/lib/libtbbmalloc.dylib
#install_name_tool -id @rpath/libtbbmalloc_proxy.dylib $LOCAL/lib/libtbbmalloc_proxy.dylib
cd ${ROOT}
