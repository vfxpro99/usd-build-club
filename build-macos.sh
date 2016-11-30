#!/bin/bash

if hash cmake 2>/dev/null; then
  echo "Detected cmake."
else
  echo "cmake not detected, please install it, and try again"
  exit 1
fi

PREREQ_SCRIPTDIR=`dirname $0`

echo "-------------------------------------------------"
echo "1/5 Building Prerequsities for USD"
echo "-------------------------------------------------"

source ${PREREQ_SCRIPTDIR}/build-prerequisites-macos.sh
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build prerequisites, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "2/5 Getting the latest USD dev code"
echo "-------------------------------------------------"

if [ ! -f ../USD/.git/config ]; then
  cd ..
  git clone https://github.com/PixarAnimationStudios/USD.git
fi

cd ${ROOT}/../USD
git checkout dev
git pull
cd ${ROOT}

echo "-------------------------------------------------"
echo "3/5 Configuring the Xcode build for USD"
echo "-------------------------------------------------"

source ${PREREQ_SCRIPTDIR}/configure-macos.sh Xcode
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to configure build for Xcode, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "4/5 Building and installing USD"
echo "-------------------------------------------------"
cmake --build . --target install --config Release
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build USD, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "5/5 Finalizing the build"
echo "-------------------------------------------------"

# done
