#!/bin/bash

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

if hash python -m pip 2>/dev/null; then
  echo "detected pip"
else
  sudo python -m easy_install pip
fi

sudo python -m pip install --install-option="--prefix=$LOCAL"  --upgrade PyOpenGL PyOpenGL-accelerate
