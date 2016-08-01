#! /bin/sh
if [ ! -f local/lib/libdouble-conversion.a ]; then

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
  if [ ! -f local/include/double-conversion ]; then
    mkdir -p local/include/double-conversion
  fi

  ROOT=$(pwd)
  cd prereq
  if [ ! -f double-conversion/.git/config ]; then
    git clone https://github.com/google/double-conversion.git
  else
    cd double-conversion; git pull; cd ..
  fi
  cd double-conversion
  cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local double-conversion
  make -j 4
  cd ../..
  cp prereq/double-conversion/libdouble-conversion.a ${ROOT}/local/lib
  cp prereq/double-conversion/double-conversion/*.h ${ROOT}/local/include/double-conversion
  cd ${ROOT}
fi
