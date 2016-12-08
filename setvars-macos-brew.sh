#!/bin/bash

CURRENT=$(pwd)
BUILDDIR=${CURRENT}/homebrew

export PATH=${BUILDDIR}/bin:$PATH
export PYTHONPATH=$PYTHONPATH:${BUILDDIR}/lib/python:${BUILDDIR}/lib/python2.7/site-packages
export PXR_PLUGINPATH_NAME=${BUILDDIR}/share/usd/plugins/
