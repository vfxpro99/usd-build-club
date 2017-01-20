#!/bin/bash

CONFIGURE_SCRIPTDIR=`dirname $0`
ROOT=$(pwd)
SOURCEDIR="`cd ${CONFIGURE_SCRIPTDIR}/../USD;pwd`"
cd ${ROOT}
BUILDDIR=${ROOT}/local

if [ $# -ge 2 ]; then
  BUILDDIR=$2
fi

echo "build from USD sources at ${SOURCEDIR}/pxr"
echo "local dir for prerequisites is ${BUILDDIR}"

# Note TBB_LIBRARY will be removed soon, once the dev/master branches agree

if [ $# -ge 1 ]; then
  if [[ "$1" = "Maya" ]]; then
    echo "Configuring for Xcode & Maya"
    cmake ${SOURCEDIR} \
      -DCMAKE_INSTALL_PREFIX="${BUILDDIR}" \
      -DCMAKE_PREFIX_PATH="${BUILDDIR}" \
      -DPXR_INSTALL_LOCATION="$HOME/Library/Pixar/USD_maya/local/third_party/maya/plugin/" \
      -DPXR_BUILD_MAYA_PLUGIN=1 \
      -DPXR_BUILD_IMAGING=1 -DPXR_BUILD_USD_IMAGING=1 \
      -DPXR_BUILD_ALEMBIC_PLUGIN=0 \
      -DMAYA_LOCATION=/Applications/Autodesk/maya2017 \
      -DTBB_LIBRARY=/Applications/Autodesk/maya2017/Maya.app/Contents/MacOS \
      -DTBB_LIBRARIES=/Applications/Autodesk/maya2017/Maya.app/Contents/MacOS \
      -DMAYA_tbb_LIBRARY=/Applications/Autodesk/maya2017/Maya.app/Contents/MacOS \
      -DPXR_tbb_LIBRARY=/Applications/Autodesk/maya2017/Maya.app/Contents/MacOS/libtbb.dylib \
      -DTBB_ROOT_DIR=/Applications/Autodesk/maya2017/include \
      -DPXR_MALLOC_LIBRARY:path=/Applications/Autodesk/maya2017/Maya.app/Contents/MacOS/libtbbmalloc.dylib \
      -DPYTHON_EXECUTABLE=/Applications/Autodesk/maya2017/Maya.app/Contents/Frameworks/Python.framework/Versions/2.7/bin/python2.7 \
      -DPYTHON_INCLUDE_DIR=/Applications/Autodesk/maya2017/Maya.app/Contents/Frameworks/Python.framework/Versions/2.7/include/python2.7 \
      -DPYTHON_LIBRARY=/Applications/Autodesk/maya2017/Maya.app/Contents/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib \
      -DPYTHON_LIBRARIES=/Applications/Autodesk/maya2017/Maya.app/Contents/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib \
      -DPYSIDE_BIN_DIR="/Applications/Autodesk/maya2017/Maya.app/Contents/bin" \
      -DALEMBIC_DIR="${BUILDDIR}" \
      -DDOUBLE_CONVERSION_DIR="${BUILDDIR}" \
      -DGLEW_LOCATION="${BUILDDIR}" \
      -DOIIO_LOCATION="${BUILDDIR}" \
      -DOPENEXR_ROOT_DIR="${BUILDDIR}" \
      -DOPENSUBDIV_ROOT_DIR="${BUILDDIR}" \
      -DQT_ROOT_DIR="${BUILDDIR}" \
      -DPTEX_LOCATION="${BUILDDIR}" \
      -DBoost_INCLUDE_DIR="${BUILDDIR}/include" -DBoost_LIBRARY_DIR="${BUILDDIR}/lib" \
      -G Xcode
    return
  fi
  if [[ "$1" = "Xcode" ]]; then
    echo "Configuring for Xcode"
    cmake ${SOURCEDIR} \
      -DCMAKE_INSTALL_PREFIX="${BUILDDIR}" \
      -DCMAKE_PREFIX_PATH="${BUILDDIR}" \
      -DALEMBIC_DIR="${BUILDDIR}" \
      -DDOUBLE_CONVERSION_DIR="${BUILDDIR}" \
      -DGLEW_LOCATION="${BUILDDIR}" \
      -DOIIO_LOCATION="${BUILDDIR}" \
      -DOPENEXR_ROOT_DIR="${BUILDDIR}" \
      -DOPENSUBDIV_ROOT_DIR="${BUILDDIR}" \
      -DQT_ROOT_DIR="${BUILDDIR}" \
      -DPTEX_LOCATION="${BUILDDIR}" \
      -DTBB_ROOT_DIR="${BUILDDIR}" \
      -DPYSIDE_BIN_DIR="{$ROOT}/homebrew/bin" \
      -DBoost_INCLUDE_DIR="${BUILDDIR}/include" -DBoost_LIBRARY_DIR="${BUILDDIR}/lib" \
      -G Xcode
    return
  fi
  echo "Configuring for make"
  cmake ${SOURCEDIR} \
    -DCMAKE_INSTALL_PREFIX="${BUILDDIR}" \
    -DCMAKE_PREFIX_PATH="${BUILDDIR}" \
    -DALEMBIC_DIR="${BUILDDIR}" \
    -DDOUBLE_CONVERSION_DIR="${BUILDDIR}" \
    -DGLEW_LOCATION="${BUILDDIR}" \
    -DOIIO_LOCATION="${BUILDDIR}" \
    -DOPENEXR_ROOT_DIR="${BUILDDIR}" \
    -DOPENSUBDIV_ROOT_DIR="${BUILDDIR}" \
    -DQT_ROOT_DIR="${BUILDDIR}" \
    -DPYSIDE_BIN_DIR="{$ROOT}/homebrew/bin" \
    -DPTEX_LOCATION="${BUILDDIR}" \
    -DTBB_ROOT_DIR="${BUILDDIR}" \
    -DBoost_INCLUDE_DIR="${BUILDDIR}/include" -DBoost_LIBRARY_DIR="${BUILDDIR}/lib"
fi
