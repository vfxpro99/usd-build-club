#! /bin/sh

if [ ! -f local/lib/libtbb.dylib ]; then

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
  curl -L -o tbb.tgz https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20141204oss_src.tgz
  tar -zxf tbb.tgz
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
