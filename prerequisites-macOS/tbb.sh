#!/bin/bash

mkdir -p prereq
mkdir -p local/lib
mkdir -p local/bin
mkdir -p local/include

ROOT=$(pwd)
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
cp prereq/tbb44_20151115oss/build/macos_intel64_*_release/libtbb.dylib local/lib
cp -R prereq/tbb44_20151115oss/include/serial local/include/serial
cp -R prereq/tbb44_20151115oss/include/tbb local/include/tbb
cd local/lib
install_name_tool -id @rpath/libtbb.dylib libtbb.dylib
#install_name_tool -id @rpath/libtbbmalloc.dylib libtbbmalloc.dylib
#install_name_tool -id @rpath/libtbbmalloc_proxy.dylib libtbbmalloc_proxy.dylib
cd ${ROOT}

