#!/bin/bash

if [ ! -f local/bin/bison ]; then
	mkdir -p prereq
	mkdir -p local/lib
	mkdir -p local/bin
	mkdir -p local/include

	ROOT=$(pwd)
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
