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

PATH=$PATH:$ROOT/homebrew/bin
PYTHONPATH=$PYTHONPATH:$ROOT/local/lib/python2.7/site-packages
#DYLD_LIBRARY_PATH=$ROOT/local/lib/python2.7/site-packages/PySide

if hash cmake 2>/dev/null; then
  echo "cmake up to date"
else
  $BREW install cmake
fi

$BREW update
$BREW upgrade

echo "-------------------------------------------------"
echo "2/7 Updating blender prerequisites"
echo "-------------------------------------------------"

echo "-------------------------------------------------"
echo "3/7 Building additional USD prerequisites"
echo "-------------------------------------------------"

echo --- double-conversion ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/double-conversion.sh $LOCAL
rc=$?
if [ $rc -ne 0 ]; then
  exit $rc
fi

echo --- ptex ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/ptex.sh $LOCAL
rc=$?
if [ $rc -ne 0 ]; then
  exit $rc
fi

# todo jinja2 PyOpenGL PyOpenGLAccelerate

echo --- boost python ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/boost_blender.sh $LOCAL
rc=$?
if [ $rc -ne 0 ]; then
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
BLENDERDEPS="$ROOT/../lib/darwin-9.x.universal"

export PYTHONPATH="/Applications/blender.app/Contents/Resources/2.78/python/lib/python3.5:/Applications/blender.app/Contents/Resources/2.78/python/lib/python3.5/site-packages"

cmake ../USD \
  -DCMAKE_INSTALL_PREFIX="${BUILDDIR}" \
  -DCMAKE_PREFIX_PATH="${BUILDDIR}" \
  -DALEMBIC_DIR="${BLENDERDEPS}/alembic" \
  -DDOUBLE_CONVERSION_DIR="${BUILDDIR}" \
  -DGLEW_LOCATION="${BLENDERDEPS}/glew" \
  -DOIIO_LOCATION="${BLENDERDEPS}/openimageio" \
  -DOIIO_LIBRARY_DIR="${BLENDERDEPS}/openimageio/lib" \
  -DOPENEXR_LIBRARY_DIR="${BLENDERDEPS}/openexr/lib" \
  -DOPENEXR_INCLUDE_DIR="${BLENDERDEPS}/openexr/include" \
  -DOPENSUBDIV_ROOT_DIR="${BLENDERDEPS}/opensubdiv" \
  -DPTEX_LOCATION="${BUILDDIR}" \
    -DTBB_LIBRARY="${BLENDERDEPS}/tbb/lib" \
    -DTBB_LIBRARIES="${BLENDERDEPS}/tbb/lib" \
    -DPXR_tbb_LIBRARY="${BLENDERDEPS}/tbb/lib/libtbb.a" \
    -DTBB_ROOT_DIR="${BLENDERDEPS}" \
  -DBoost_INCLUDE_DIR="${BLENDERDEPS}/boost/include" \
  -DBoost_LIBRARY_DIR="${BLENDERDEPS}/boost/lib" \
  -DPYTHON_EXECUTABLE="/Applications/blender.app/Contents/Resources/2.78/python/bin/python3.5m" \
  -DPYTHON_INCLUDE_DIR="${BLENDERDEPS}/python/include/python3.5m" \
  -DPYTHON_LIBRARY="${BLENDERDEPS}/python/lib/python3.5/libpython3.5m.a" \
  -DPYTHON_LIBRARIES="${BLENDERDEPS}/python/lib/python3.5/libpython3.5m.a" \
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
