#! /bin/sh
if [ ! -f local/lib/libhdf5.a ]; then

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
  if [ ! -f hdf5/.git/config ]; then
    git clone git://github.com/vfxpro99/hdf5.git
  else
    cd hdf5; git pull; cd ..
  fi
  cd hdf5
  mkdir hdf5_build
  cd hdf5_build
  cmake -DHDF5_BUILD_HL_LIB=1 -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=./hdf5-stage \
        -DCMAKE_INSTALL_PREFIX=${ROOT}/local ..
  make -j 4
  make install
  cd ${ROOT}
fi
