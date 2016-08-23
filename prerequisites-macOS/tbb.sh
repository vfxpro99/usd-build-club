#!/bin/bash

if [ ! -f local/lib/libtbb.dylib ]; then

  mkdir -p prereq
  mkdir -p local/lib
  mkdir -p local/bin
  mkdir -p local/include

  ROOT=$(pwd)
  cd prereq
  if [ ! -f tbb.tgz ]; then
    curl -L -o tbb.tgz https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20141204oss_src.tgz
  fi
  if [ ! tbb43_20141204oss/README ]; then
    tar -zxf tbb.tgz
  fi
  cd tbb43_20141204oss

  make -j 4
  cd ${ROOT}
  # only copy libtbb because the malloc libs are very problematic
  cp prereq/tbb43_20141204oss/build/macos_intel64_*_release/libtbb.dylib local/lib
  cp -R prereq/tbb43_20141204oss/include/serial local/include/serial
  cp -R prereq/tbb43_20141204oss/include/tbb local/include/tbb
  cd local/lib
  install_name_tool -id @rpath/libtbb.dylib libtbb.dylib
  #install_name_tool -id @rpath/libtbbmalloc.dylib libtbbmalloc.dylib
  #install_name_tool -id @rpath/libtbbmalloc_proxy.dylib libtbbmalloc_proxy.dylib
  cd ${ROOT}
fi
