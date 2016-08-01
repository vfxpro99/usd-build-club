#! /bin/sh

SCRIPTDIR="$(dirname "$(which "$0")")"

# shiboken

ROOT=$(pwd)
cd prereq
curl -L -o shiboken.tgz http://download.qt.io/official_releases/pyside/shiboken-1.2.2.tar.bz2
gunzip shiboken.tgz
tar -xvf shiboken.tar
cd shiboken-1.2.2
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local -DALTERNATIVE_QT_INCLUDE_DIR=${ROOT}/local ..
make -j 4; make install
cd ${ROOT}/prereq

# pyside

curl -L -o pyside-qt.tgz http://download.qt.io/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2
gunzip pyside-qt.tgz
tar -xvf pyside-qt.tar
cd pyside-qt4.8+1.2.2
cp /Users/dp/Projects/usd_160409/xcbuild/usd_prereq_osx/pyside.cmake CMakeLists.txt
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local -DALTERNATIVE_QT_INCLUDE_DIR=${ROOT}/local -DBUILD_TESTS=False -DENABLE_ICECC=0 ..
make -j 4; make install
cd ${ROOT}/prereq

# pyside-tools

curl -L -o pyside-tools.tgz https://github.com/PySide/Tools/archive/0.2.15.tar.gz
gunzip pyside-tools.tgz
tar -xvf pyside-tools.tar
cd Tools-0.2.15
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=${ROOT}/local -DALTERNATIVE_QT_INCLUDE_DIR=${ROOT}/local ..
make -j 4; make install

cd ${ROOT}
