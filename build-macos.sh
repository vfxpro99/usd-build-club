#!/bin/bash

# optional first argument: Debug

PREREQ_SCRIPTDIR=`dirname $0`
ROOT=$(pwd)
BREW=$ROOT/homebrew/bin/brew

echo "-------------------------------------------------"
echo "1/6 Checking Cmake"
echo "-------------------------------------------------"

if [ ! -f "$BREW" ]; then
  source $PREREQ_SCRIPTDIR/brew/brew-install.sh
fi

$BREW update
$BREW upgrade
$BREW install cmake

PATH=${PATH}:$ROOT/homebrew/bin

if hash cmake 2>/dev/null; then
  echo "Cmake up to date"
else
  echo "cmake not detected, exitting."
  exit 1
fi

echo "-------------------------------------------------"
echo "2/6 Building Prerequsities for USD"
echo "-------------------------------------------------"

$PREREQ_SCRIPTDIR/build-prerequisites-macos.sh $ROOT/local

rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build prerequisites, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "3/6 Getting the latest USD dev code"
echo "-------------------------------------------------"

if [ ! -f ../USD/.git/config ]; then
  cd ..
  git clone https://github.com/PixarAnimationStudios/USD.git
fi

cd "$ROOT/../USD"
git checkout dev
git pull
cd "$ROOT"

echo "-------------------------------------------------"
echo "4/6 Configuring the Xcode build for USD"
echo "-------------------------------------------------"

source ${PREREQ_SCRIPTDIR}/configure-macos.sh Xcode
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to configure build for Xcode, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "5/6 Building and installing USD"
if [[ "$1" = "Debug" ]]; then
  echo "  Debug build in progress."
  cmake --build . --target install --config Debug
else
  echo "  Release build in progress."
  cmake --build . --target install --config Release
fi
echo "-------------------------------------------------"

rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build USD, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "6/6 Finalizing the build"
echo "-------------------------------------------------"

# done
