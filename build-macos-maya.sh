#!/bin/bash

if [ ! -f /Applications/Autodesk/maya2017/include/maya/MFn.h ]; then
  echo "Install the Maya devkit according to the instructions at https://github.com/vfxpro99/usd-build-club and try again."
  exit 1
fi

if hash cmake 2>/dev/null; then
  echo "Detected cmake."
else
  echo "cmake not detected, please install it, and try again"
  exit 1
fi

ROOT=$(pwd)
PREREQ_SCRIPTDIR=`dirname $0`
BUILDDIR="$ROOT/local"

echo "-------------------------------------------------"
echo "1/5 Building Prerequsities for the maya plugin"
echo "-------------------------------------------------"

source ${PREREQ_SCRIPTDIR}/build-prerequisites-macos-maya.sh
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

SOURCEDIR="`pwd`"

cd ${ROOT}

echo "-------------------------------------------------"
echo "3/5 Configuring the build for the Maya plugin"
echo "-------------------------------------------------"

echo "Configuring for Xcode & Maya in ${SOURCEDIR}"
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


echo "-------------------------------------------------"
echo "4/5 Building and installing the Maya plugin"
echo "-------------------------------------------------"
cmake --build . --target install --config Release
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build for Maya, exiting"
  exit $rc
fi

echo "Note that the cmake directory link warnings are apparently harmless."


PLUG_ROOT=@loader_path/../../../third_party/maya/lib
LIB_ROOT=@loader_path/../../../lib
BUNDLE=${ROOT}/local/third_party/maya/plugin/pxrUsd.bundle

echo "-------------------------------------------------"
echo "5/5 Finalizing the build of the Maya plugin at ${BUNDLE}"
echo "-------------------------------------------------"
#echo "temp: copying plugin per Maya convention"
cp local/third_party/maya/plugin/pxrUsd.dylib local/third_party/maya/plugin/pxrUsd.bundle

# echo "temp: Fixing up rpaths in dylibs specific to Maya plug-in"
# install_name_tool -change @rpath/libpxrUsdMayaGL.dylib ${PLUG_ROOT}/libpxrUsdMayaGL.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdMaya.dylib ${PLUG_ROOT}/libusdMaya.dylib ${BUNDLE}
# install_name_tool -change @rpath/libpx_vp20.dylib ${PLUG_ROOT}/libpx_vp20.dylib ${BUNDLE}

# echo "temp: Fixing up rpaths in dylibs for all required USD dylibs"
# install_name_tool -change @rpath/libar.dylib ${LIB_ROOT}/libar.dylib ${BUNDLE}
# install_name_tool -change @rpath/libarch.dylib ${LIB_ROOT}/libarch.dylib ${BUNDLE}
# install_name_tool -change @rpath/libcameraUtil.dylib ${LIB_ROOT}/libcameraUtil.dylib ${BUNDLE}
# install_name_tool -change @rpath/libgal.dylib ${LIB_ROOT}/libgal.dylib ${BUNDLE}
# install_name_tool -change @rpath/libgarch.dylib ${LIB_ROOT}/libgarch.dylib ${BUNDLE}
# install_name_tool -change @rpath/libgf.dylib ${LIB_ROOT}/libgf.dylib ${BUNDLE}
# install_name_tool -change @rpath/libglf.dylib ${LIB_ROOT}/libglf.dylib ${BUNDLE}
# install_name_tool -change @rpath/libhd.dylib ${LIB_ROOT}/libhd.dylib ${BUNDLE}
# install_name_tool -change @rpath/libhdx.dylib ${LIB_ROOT}/libhdx.dylib ${BUNDLE}
# install_name_tool -change @rpath/libhf.dylib ${LIB_ROOT}/libhf.dylib ${BUNDLE}
# install_name_tool -change @rpath/libjs.dylib ${LIB_ROOT}/libjs.dylib ${BUNDLE}
# install_name_tool -change @rpath/libkind.dylib ${LIB_ROOT}/libkind.dylib ${BUNDLE}
# install_name_tool -change @rpath/libpcp.dylib ${LIB_ROOT}/libpcp.dylib ${BUNDLE}
# install_name_tool -change @rpath/libplug.dylib ${LIB_ROOT}/libplug.dylib ${BUNDLE}
# install_name_tool -change @rpath/libpxOsd.dylib ${LIB_ROOT}/libpxOsd.dylib ${BUNDLE}
# install_name_tool -change @rpath/libsdf.dylib ${LIB_ROOT}/libsdf.dylib ${BUNDLE}
# install_name_tool -change @rpath/libtf.dylib ${LIB_ROOT}/libtf.dylib ${BUNDLE}
# install_name_tool -change @rpath/libtracelite.dylib ${LIB_ROOT}/libtracelite.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusd.dylib ${LIB_ROOT}/libusd.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdGeom.dylib ${LIB_ROOT}/libusdGeom.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdHydra.dylib ${LIB_ROOT}/libusdHydra.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdImaging.dylib ${LIB_ROOT}/libusdImaging.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdImagingGL.dylib ${LIB_ROOT}/libusdImagingGL.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdRi.dylib ${LIB_ROOT}/libusdRi.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdShade.dylib ${LIB_ROOT}/libusdShade.dylib ${BUNDLE}
# install_name_tool -change @rpath/libusdUtils.dylib ${LIB_ROOT}/libusdUtils.dylib ${BUNDLE}
# install_name_tool -change @rpath/libvt.dylib ${LIB_ROOT}/libvt.dylib ${BUNDLE}
# install_name_tool -change @rpath/libwork.dylib ${LIB_ROOT}/libwork.dylib ${BUNDLE}

# echo "temp: Fixing up rpaths in boost dylibs required by USD"
# install_name_tool -change @rpath/libboost_date_time.dylib ${LIB_ROOT}/libboost_date_time.dylib ${BUNDLE}
# install_name_tool -change @rpath/libboost_iostreams.dylib ${LIB_ROOT}/libboost_iostreams.dylib ${BUNDLE}
# install_name_tool -change @rpath/libboost_program_options.dylib ${LIB_ROOT}/libboost_program_options.dylib ${BUNDLE}
# install_name_tool -change @rpath/libboost_python.dylib ${LIB_ROOT}/libboost_python.dylib ${BUNDLE}
# install_name_tool -change @rpath/libboost_regex.dylib ${LIB_ROOT}/libboost_regex.dylib ${BUNDLE}
# install_name_tool -change @rpath/libboost_system.dylib ${LIB_ROOT}/libboost_system.dylib ${BUNDLE}

# echo "temp: Fixing up rpaths in dylibs required by USD"
# install_name_tool -change @rpath/libGLEW.2.0.0.dylib ${LIB_ROOT}/libGLEW.2.0.0.dylib ${BUNDLE}
# install_name_tool -change @rpath/libHalf.12.dylib ${LIB_ROOT}/libHalf.12.dylib ${BUNDLE}
# install_name_tool -change @rpath/libOpenImageIO.1.7.dylib ${LIB_ROOT}/libOpenImageIO.1.7.dylib ${BUNDLE}
# install_name_tool -change @rpath/libOpenImageIO_Util.1.7.dylib ${LIB_ROOT}/libOpenImageIO_Util.1.7.dylib ${BUNDLE}
# install_name_tool -change @rpath/libosdCPU.3.2.0.dylib ${LIB_ROOT}/libosdCPU.3.2.0.dylib ${BUNDLE}
# install_name_tool -change @rpath/libosdGPU.3.2.0.dylib ${LIB_ROOT}/libosdGPU.3.2.0.dylib ${BUNDLE}
# install_name_tool -change @rpath/libPtex.dylib ${LIB_ROOT}/libPtex.dylib ${BUNDLE}
# install_name_tool -change @rpath/libIlmImf-2_2.22.dylib ${LIB_ROOT}/libIlmImf-2_2.22.dylib ${BUNDLE}
# install_name_tool -change @rpath/libIlmImfUtil-2_2.22.dylib ${LIB_ROOT}/libIlmImfUtil-2_2.22.dylib ${BUNDLE}
# install_name_tool -change @rpath/libImath-2_2.22.dylib ${LIB_ROOT}/libImath-2_2.22.dylib ${BUNDLE}
# install_name_tool -change @rpath/libIthread-2_2.22.dylib ${LIB_ROOT}/libIthread-2_2.22.dylib ${BUNDLE}

# echo "temp: Fixing rpaths in OpenImageIO"
# install_name_tool -change @rpath/libIlmImf-2_2.22.dylib @loader_path/libIlmImf-2_2.22.dylib local/lib/libOpenImageIO.1.7.dylib
# install_name_tool -change @rpath/libIlmImfUtil-2_2.22.dylib @loader_path/libIlmImfUtil-2_2.22.dylib local/lib/libOpenImageIO.1.7.dylib
# install_name_tool -change @rpath/libImath-2_2.22.dylib @loader_path/lib/libImath-2_2.22.dylib local/lib/libOpenImageIO.1.7.dylib
# install_name_tool -change @rpath/libIthread-2_2.22.dylib @loader_path/lib/libIthread-2_2.22.dylib local/lib/libOpenImageIO.1.7.dylib



# TODO INSTALL_ROOT should be coming from the command line!

INSTALL_ROOT=/tmp/maya-usd
mkdir -p $INSTALL_ROOT/lib/python/pxr
cp -R local/lib/python/pxr $INSTALL_ROOT/lib/python
cp local/lib/*.dylib $INSTALL_ROOT/lib

mkdir -p $INSTALL_ROOT/share/usd/plugins
cp -R local/share/usd/plugins $INSTALL_ROOT/share/usd

mkdir -p $INSTALL_ROOT/bin
cp local/bin/usd* $INSTALL_ROOT/bin

mkdir -p $INSTALL_ROOT/plugin
cp -R local/plugin $INSTALL_ROOT

mkdir -p $INSTALL_ROOT/third_party/maya/lib
cp local/third_party/maya/lib/* $INSTALL_ROOT/third_party/maya/lib

mkdir -p $INSTALL_ROOT/third_party/maya/plugin
cp local/third_party/maya/plugin/* $INSTALL_ROOT/third_party/maya/plugin

mkdir -p $INSTALL_ROOT/third_party/maya/share
cp -R local/third_party/maya/share $INSTALL_ROOT/third_party/maya

mkdir -p $INSTALL_ROOT/third_party/maya/scripts

# TODO maya-rpath has to know about $INSTALL_ROOT!!!!
python ${PREREQ_SCRIPTDIR}/maya/maya-rpath.py

echo "Copy $INSTALL_ROOT/ to ~/Library/Pixar/ on the user's machine" > $INSTALL_ROOT/README.txt
echo "Modify Maya.env at ~/Library/Preferences/Autodesk/maya/2017/Maya.env with the Maya.env found here." >> $INSTALL_ROOT/README.txt
echo "Open Maya and open the Plugin manager (Windows > Settings/Preferences > Plugin-manager)" >> $INSTALL_ROOT/README.txt
echo "Click Loaded beside pxrUsd.bundle, and click Autoload if you want the plugin automatically loaded at start." >> $INSTALL_ROOT/README.txt
echo "" >> $INSTALL_ROOT/README.txt

echo "MAYA_PLUG_IN_PATH=$MAYA_PLUGIN_PATH:\$HOME/Library/Pixar/third_party/maya/plugin/::\$HOME/Library/Pixar/third_party/maya/share/usd/plugins/usdMaya/resources/" > $INSTALL_ROOT/Maya.env
echo "MAYA_SCRIPT_PATH=$MAYA_SCRIPT_PATH:\$HOME/Library/Pixar/third_party/maya/scripts/:\$HOME/Library/Pixar/third_party/maya/share/usd/plugins/usdMaya/resources/" >> $INSTALL_ROOT/Maya.env
echo "PYTHONPATH=$PYTHONPATH:\$HOME/Library/Pixar/lib/python/" >> $INSTALL_ROOT/Maya.env
echo "" >> $INSTALL_ROOT/Maya.env

echo "The maya plug in has been finalized at $INSTALL_ROOT"
echo "Please see $INSTALL_ROOT/README.txt for more information"
