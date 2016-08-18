#!/bin/bash
if [ -f /usr/local/lib/libQt4Core.dylib ]; then
  exit 0
fi

if [ ! -f prereq ]; then
  mkdir -p prereq
fi

ROOT=$(pwd)
PREREQ_SCRIPTDIR=`dirname $0`
QT_DIR=qt-everywhere-opensource-src-4.8.7

cd prereq

if [ ! -f ${QT_DIR}/README ]; then
  curl -L -o qt-everywhere.tgz http://download.qt.io/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz
  rc=$?
  if [ $rc -ne 0 ]; then
    echo Could not retrieve qt tarball
    exit $rc
  fi
  gunzip qt-everywhere.tgz
  rc=$?
  if [ $rc -ne 0 ]; then
    echo Could not unzip qt tarball
    exit $rc
  fi
  tar -xvf qt-everywhere.tar
  rc=$?
  if [ $rc -ne 0 ]; then
    echo Could not untar qt tarball
    exit $rc
  fi
fi

#configure hacked to force generation of STL support required for pyside. Detection is busted on el capitan+.
cp ${ROOT}/${PREREQ_SCRIPTDIR}/configure.qt4 ${ROOT}/prereq/${QT_DIR}/configure

mkdir build/qt-everywhere
cd build/qt-everywhere

# learn more:
# http://doc.qt.io/qt-5/configure-options.html

sudo ${ROOT}/prereq/${QT_DIR}/configure -prefix /usr/local \
            -opensource -confirm-license -silent \
            -no-qt3support \
            -nomake examples -nomake demos -nomake docs -nomake translations \
            -no-phonon -no-multimedia \
            -shared -stl -no-framework \
            -arch x86_64 -platform unsupported/macx-clang \
            -v -continue

rc=$?
if [ $rc -ne 0 ]; then
  echo Could not configure qt
  exit $rc
fi

# update file for el capitan compatibility
cp ${ROOT}/${PREREQ_SCRIPTDIR}/qpaintengine_mac.cpp ${ROOT}/prereq/${QT_DIR}/src/gui/painting/qpaintengine_mac.cpp
sudo make -j 4
rc=$?
if [ $rc -ne 0 ]; then
  echo Could not make qt
  exit $rc
fi

sudo make install
rc=$?
if [ $rc -ne 0 ]; then
  echo Could not install qt
  exit $rc
fi

#sudo cp bin/qmake /usr/local/bin/

cd ${ROOT}
