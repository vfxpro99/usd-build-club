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

if [ ! -f local/bin/flex ]; then
	cd prereq

	if [ ! -f flex-2.5.39/.git/config ]; then
	  git clone https://github.com/vfxpro99/flex-2.5.39.git
	fi
	cd flex-2.5.39; git pull
	./configure --prefix ${LOCAL}
	make -j 4
	make install
	cd ${ROOT}
fi
