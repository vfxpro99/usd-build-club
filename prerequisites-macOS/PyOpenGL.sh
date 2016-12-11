#!/bin/bash

ROOT=$(pwd)
LOCAL=${ROOT}/local

if [ $# -ge 1 ]; then
  LOCAL=$1
fi

if hash pip 2>/dev/null; then
  echo "detected pip"
else
  sudo easy_install pip
fi

pip install --install-option="--prefix=$LOCAL" \
    --upgrade PyOpenGL PyOpenGL-accelerate
