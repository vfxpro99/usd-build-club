#!/bin/bash

CURRENT=$(pwd)
BUILDDIR=${CURRENT}/local

export PATH=$PATH:${BUILDDIR}/lib:${BUILDDIR}/bin
export PYTHONPATH=$PYTHONPATH:${BUILDDIR}/lib/python
