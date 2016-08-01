#! /bin/sh

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
pushd prereq

if [ ! -f flex-2.5.39/.git/config ]; then
  git clone https://github.com/vfxpro99/flex-2.5.39.git
else
  cd flex-2.5.39; git pull; cd ..
fi
cd flex-2.5.39
./configure --prefix ${ROOT}/local
make -j 4
make install
cd ${ROOT}
