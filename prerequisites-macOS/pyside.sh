#!/bin/bash

ROOT=$(pwd)
PREREQ_SCRIPTDIR=`dirname $0`

if hash python -m pip 2>/dev/null; then
  echo "detected pip"
else
  sudo python -m easy_install pip
fi

sudo python -m pip install --index-url=https://download.qt.io/official_releases/QtForPython/ pyside2 --trusted-host download.qt.io

