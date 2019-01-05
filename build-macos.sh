#!/bin/bash

# optional first argument: Debug

PREREQ_SCRIPTDIR=`dirname $0`
ROOT=$(pwd)

echo "-------------------------------------------------"
echo "1/7 Validating cmake and brew"
echo "-------------------------------------------------"

PATH=$ROOT/local/bin:$PATH

if hash cmake 2>/dev/null; then
  echo "cmake up to date"
else
  echo "Please install cmake and run this script again."
  exit 1
fi

PYTHONPATH=$ROOT/local/lib/python2.7/site-packages:$PYTHONPATH

echo "-------------------------------------------------"
echo "2/7 PySide for usdview"
echo "-------------------------------------------------"

if hash qmake 2>/dev/null; then
  echo "qmake found, if PySide exists, usdview will be built"
else
  echo "Usdview uses PySide2"
  echo "python -m pip install --index-url=https://download.qt.io/official_releases/QtForPython/ pyside2 --trusted-host download.qt.io"
fi

echo "-------------------------------------------------"
echo "3/7 Building Prerequsities for USD"
echo "-------------------------------------------------"

$PREREQ_SCRIPTDIR/build-prerequisites-macos.sh $ROOT/local

rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build prerequisites, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "4/7 Getting the latest USD dev code"
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
echo "5/7 Configuring an Xcode build for USD"
echo "-------------------------------------------------"

BUILDDIR="$ROOT/local"

cmake ../USD \
  -DCMAKE_INSTALL_PREFIX="$BUILDDIR" \
  -DCMAKE_PREFIX_PATH="$BUILDDIR" \
  -DALEMBIC_DIR="$BUILDDIR" \
  -DGLEW_LOCATION="$BUILDDIR" \
  -DOIIO_LOCATION="$BUILDDIR" \
  -DOPENEXR_ROOT_DIR="$BUILDDIR" \
  -DOPENSUBDIV_ROOT_DIR="$BUILDDIR" \
  -DPTEX_LOCATION="$BUILDDIR" \
  -DTBB_ROOT_DIR="$BUILDDIR" \
  -DBoost_INCLUDE_DIR="$BUILDDIR/include" \
  -DBoost_LIBRARY_DIR="$BUILDDIR/lib"

rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to configure build for Xcode, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "6/7 Building and installing USD"
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
echo "7/7 Finalizing the build"
echo "-------------------------------------------------"

# currently nothing to do
