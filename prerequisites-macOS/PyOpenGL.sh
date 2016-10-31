#!/bin/bash

if hash pip 2>/dev/null; then
  echo "detected pip"
else
  sudo easy_install pip
fi

sudo pip install PyOpenGL PyOpenGL-accelerate
