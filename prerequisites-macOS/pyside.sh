#!/bin/bash

ROOT=$(pwd)
PREREQ_SCRIPTDIR=`dirname $0`

QT_BUILD_ROOT=/usr/local

# shiboken

cd prereq
curl -L -o shiboken.tgz http://download.qt.io/official_releases/pyside/shiboken-1.2.2.tar.bz2
gunzip shiboken.tgz
tar -xvf shiboken.tar

mkdir -p build/shiboken
cd build/shiboken

cmake -DCMAKE_INSTALL_PREFIX=${QT_BUILD_ROOT} -DALTERNATIVE_QT_INCLUDE_DIR=${QT_BUILD_ROOT} \
      ../../shiboken-1.2.2

make -j 4; make install
cd ${ROOT}/prereq

# pyside

curl -L -o pyside-qt.tgz http://download.qt.io/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2
gunzip pyside-qt.tgz
tar -xvf pyside-qt.tar
cd pyside-qt4.8+1.2.2
cp ${ROOT}/${PREREQ_SCRIPTDIR}/pyside.cmake CMakeLists.txt
cd ..
mkdir -p build/pyside
cd build/psyide

cmake -DCMAKE_INSTALL_PREFIX=${QT_BUILD_ROOT} -DALTERNATIVE_QT_INCLUDE_DIR=${QT_BUILD_ROOT} \
      -DBUILD_TESTS=False -DENABLE_ICECC=0
      ../../pyside-qt4.8+1.2.2

make -j 4; make install
cd ${ROOT}/prereq

# pyside-tools

curl -L -o pyside-tools.tgz https://github.com/PySide/Tools/archive/0.2.15.tar.gz
gunzip pyside-tools.tgz
tar -xvf pyside-tools.tar

mkdir -p build/pyside-tools
cd build/pyside-tools

cmake -DCMAKE_INSTALL_PREFIX=${QT_BUILD_ROOT} -DALTERNATIVE_QT_INCLUDE_DIR=${QT_BUILD_ROOT} \
      ../../Tools-0.2.15

make -j 4; make install

cd ${ROOT}
