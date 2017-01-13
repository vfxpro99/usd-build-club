#!/bin/bash

# optional first argument: Debug

PREREQ_SCRIPTDIR=`dirname $0`
ROOT=$(pwd)
BREW=$ROOT/homebrew/bin/brew

echo "-------------------------------------------------"
echo "1/7 Validating brew and cmake"
echo "-------------------------------------------------"

if [ ! -f "$BREW" ]; then
  source $PREREQ_SCRIPTDIR/brew/brew-install.sh
fi

PATH=$ROOT/homebrew/bin:$PATH
PYTHONPATH=$ROOT/local/lib/python2.7/site-packages:$PYTHONPATH
PYTHONPATH=$ROOT/homebrew/lib/python2.7/site-packages:$PYTHONPATH

if hash cmake 2>/dev/null; then
  echo "cmake up to date"
else
  $BREW install cmake
fi

$BREW update
$BREW upgrade

echo "-------------------------------------------------"
echo "2/7 Installing Qt and PySide for usdview"
echo "-------------------------------------------------"

if hash qmake 2>/dev/null; then
  echo "Qt up to date"
else
  $BREW install cartr/qt4/qt
fi

$BREW install cartr/qt4/pyside
$BREW install cartr/qt4/pyside-tools

#if [ ! -f "$ROOT/local/bin/pyside-uic" ]; then
#  echo "Installing PySide. This takes several minutes."
#  pip install --install-option="--prefix=$ROOT/local/" -U PySide
#else
#  echo "PySide up to date"
#fi

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
  -DCMAKE_INSTALL_PREFIX="${BUILDDIR}" \
  -DCMAKE_PREFIX_PATH="${BUILDDIR}" \
  -DALEMBIC_DIR="${BUILDDIR}" \
  -DDOUBLE_CONVERSION_DIR="${BUILDDIR}" \
  -DGLEW_LOCATION="${BUILDDIR}" \
  -DOIIO_LOCATION="${BUILDDIR}" \
  -DOPENEXR_ROOT_DIR="${BUILDDIR}" \
  -DOPENSUBDIV_ROOT_DIR="${BUILDDIR}" \
  -DPTEX_LOCATION="${BUILDDIR}" \
  -DTBB_ROOT_DIR="${BUILDDIR}" \
  -DBoost_INCLUDE_DIR="${BUILDDIR}/include" \
  -DBoost_LIBRARY_DIR="${BUILDDIR}/lib" \
  -DQT_ROOT_DIR="$ROOT/homebrew" \
  -G Xcode

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
