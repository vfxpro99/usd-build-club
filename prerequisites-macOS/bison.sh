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

if [ ! -f local/bin/bison ]; then
	pushd prereq

	if [ ! -d bison-2.4.tar.gz ]; then
	  curl http://ftp.gnu.org/gnu/bison/bison-2.4.tar.gz > bison-2.4.tar.gz
	fi
	if [ ! -f bison-2.4 ]; then
	  tar -xf bison-2.4.tar.gz
	fi
	cd bison-2.4
	mkdir build
	./configure --prefix ${ROOT}/local
	make -j 4;make install
	cd ${ROOT}
fi
