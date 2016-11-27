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

PREREQ_SCRIPTDIR=`dirname $0`

echo "-------------------------------------------------"
echo "1/4 Building Prerequsities for the maya plugin"
echo "-------------------------------------------------"

source ${PREREQ_SCRIPTDIR}/build-prerequisites-macos-maya.sh
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build prerequisites, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "2/4 Configuring the build for the Maya plugin"
echo "-------------------------------------------------"

source ${PREREQ_SCRIPTDIR}/configure-macos.sh Maya
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to configure build for Maya, exiting"
  exit $rc
fi

echo "-------------------------------------------------"
echo "3/4 Building and installing the Maya plugin"
echo "-------------------------------------------------"
cmake --build . --target install --config Release
rc=$?
if [ $rc -ne 0 ]; then
  echo "Failed to build for Maya, exiting"
  exit $rc
fi

echo "Note that the cmake directory link warnings are apparently harmless."

echo "-------------------------------------------------"
echo "4/4 Finalizing the build of the Maya plugin"
echo "-------------------------------------------------"

echo "temp: Renaming plugin per Maya convention"
mv local/third_party/maya/plugin/pxrUsd.dylib local/third_party/maya/plugin/pxrUsd.bundle

echo "temp: Fixing up rpaths"

PLUG_ROOT=$(pwd)/local/third_party/maya/lib
LIB_ROOT=$(pwd)/local/lib
BUNDLE=$(pwd)/local/third_party/maya/plugin/pxrUsd.bundle

install_name_tool -change @rpath/libpxrUsdMayaGL.dylib ${PLUG_ROOT}/libpxrUsdMayaGL.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdMaya.dylib ${PLUG_ROOT}/libusdMaya.dylib ${BUNDLE}
install_name_tool -change @rpath/libpx_vp20.dylib ${PLUG_ROOT}/libpx_vp20.dylib ${BUNDLE}

install_name_tool -change @rpath/libar.dylib ${LIB_ROOT}/libar.dylib ${BUNDLE}
install_name_tool -change @rpath/libarch.dylib ${LIB_ROOT}/libarch.dylib ${BUNDLE}
install_name_tool -change @rpath/libcameraUtil.dylib ${LIB_ROOT}/libcameraUtil.dylib ${BUNDLE}
install_name_tool -change @rpath/libgal.dylib ${LIB_ROOT}/libgal.dylib ${BUNDLE}
install_name_tool -change @rpath/libgarch.dylib ${LIB_ROOT}/libgarch.dylib ${BUNDLE}
install_name_tool -change @rpath/libgf.dylib ${LIB_ROOT}/libgf.dylib ${BUNDLE}
install_name_tool -change @rpath/libglf.dylib ${LIB_ROOT}/libglf.dylib ${BUNDLE}
install_name_tool -change @rpath/libhd.dylib ${LIB_ROOT}/libhd.dylib ${BUNDLE}
install_name_tool -change @rpath/libhdx.dylib ${LIB_ROOT}/libhdx.dylib ${BUNDLE}
install_name_tool -change @rpath/libhf.dylib ${LIB_ROOT}/libhf.dylib ${BUNDLE}
install_name_tool -change @rpath/libjs.dylib ${LIB_ROOT}/libjs.dylib ${BUNDLE}
install_name_tool -change @rpath/libkind.dylib ${LIB_ROOT}/libkind.dylib ${BUNDLE}
install_name_tool -change @rpath/libpcp.dylib ${LIB_ROOT}/libpcp.dylib ${BUNDLE}
install_name_tool -change @rpath/libplug.dylib ${LIB_ROOT}/libplug.dylib ${BUNDLE}
install_name_tool -change @rpath/libpxOsd.dylib ${LIB_ROOT}/libpxOsd.dylib ${BUNDLE}
install_name_tool -change @rpath/libsdf.dylib ${LIB_ROOT}/libsdf.dylib ${BUNDLE}
install_name_tool -change @rpath/libtf.dylib ${LIB_ROOT}/libtf.dylib ${BUNDLE}
install_name_tool -change @rpath/libtracelite.dylib ${LIB_ROOT}/libtracelite.dylib ${BUNDLE}
install_name_tool -change @rpath/libusd.dylib ${LIB_ROOT}/libusd.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdGeom.dylib ${LIB_ROOT}/libusdGeom.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdHydra.dylib ${LIB_ROOT}/libusdHydra.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdImaging.dylib ${LIB_ROOT}/libusdImaging.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdImagingGL.dylib ${LIB_ROOT}/libusdImagingGL.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdRi.dylib ${LIB_ROOT}/libusdRi.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdShade.dylib ${LIB_ROOT}/libusdShade.dylib ${BUNDLE}
install_name_tool -change @rpath/libusdUtils.dylib ${LIB_ROOT}/libusdUtils.dylib ${BUNDLE}
install_name_tool -change @rpath/libvt.dylib ${LIB_ROOT}/libvt.dylib ${BUNDLE}
install_name_tool -change @rpath/libwork.dylib ${LIB_ROOT}/libwork.dylib ${BUNDLE}

install_name_tool -change @rpath/libboost_iostreams.dylib ${LIB_ROOT}/libboost_iostreams.dylib ${BUNDLE}
install_name_tool -change @rpath/libboost_program_options.dylib ${LIB_ROOT}/libboost_program_options.dylib ${BUNDLE}
install_name_tool -change @rpath/libboost_python.dylib ${LIB_ROOT}/libboost_python.dylib ${BUNDLE}
install_name_tool -change @rpath/libboost_regex.dylib ${LIB_ROOT}/libboost_regex.dylib ${BUNDLE}
install_name_tool -change @rpath/libboost_system.dylib ${LIB_ROOT}/libboost_system.dylib ${BUNDLE}

install_name_tool -change @rpath/libGLEW.2.0.0.dylib ${LIB_ROOT}/libGLEW.2.0.0.dylib ${BUNDLE}
install_name_tool -change @rpath/libHalf.12.dylib ${LIB_ROOT}/libHalf.12.dylib ${BUNDLE}
install_name_tool -change @rpath/libOpenImageIO.1.8.dylib ${LIB_ROOT}/libOpenImageIO.1.8.dylib ${BUNDLE}
install_name_tool -change @rpath/libOpenImageIO_Util.1.8.dylib ${LIB_ROOT}/libOpenImageIO_Util.1.8.dylib ${BUNDLE}
install_name_tool -change @rpath/libosdCPU.3.1.0.dylib ${LIB_ROOT}/libosdCPU.3.1.0.dylib ${BUNDLE}
install_name_tool -change @rpath/libosdGPU.3.1.0.dylib ${LIB_ROOT}/libosdGPU.3.1.0.dylib ${BUNDLE}
