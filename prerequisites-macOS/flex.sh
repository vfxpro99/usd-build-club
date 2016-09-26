#!/bin/bash

if [ ! -f local/bin/flex ]; then
	mkdir -p prereq
	mkdir -p local/lib
	mkdir -p local/bin
	mkdir -p local/include

	ROOT=$(pwd)
	cd prereq

	if [ ! -f flex-2.5.39/.git/config ]; then
	  git clone https://github.com/vfxpro99/flex-2.5.39.git
	fi
	cd flex-2.5.39; git pull
	./configure --prefix ${ROOT}/local
	make -j 4
	make install
	cd ${ROOT}
fi
