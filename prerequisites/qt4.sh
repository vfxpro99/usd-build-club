
#! /bin/sh

if [ ! -f prereq ]; then
  mkdir -p prereq
fi
if [ ! -f local/lib ]; then
  mkdir -p local/lib
fi
if [ ! -f local/bin ]; then
  mkdir -p local/bin
fi
if [ ! -f local/include ]; then
  mkdir -p local/include
fi

ROOT=$(pwd)
cd prereq
#curl -L -o qt-everywhere.tgz http://download.qt.io/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz
#gunzip qt-everywhere.tgz
#tar -xvf qt-everywhere.tar
cd qt-everywhere-opensource-src-4.8.7
#configure hacked to force generation of STL support required for pyside. Detection is busted on el capitan+.
cp /Users/dp/Projects/usd_160409/xcbuild/usd_prereq_osx/configure.qt4 configure
./configure -prefix ${ROOT}/local -opensource -confirm-license -no-qt3support -shared -no-multimedia -stl \
 -nomake examples -nomake demos -nomake docs -nomake translations -no-phonon -silent -no-framework \
 -arch x86_64 -platform unsupported/macx-clang -v -continue
# update file for el capitan compatibility
cp /Users/dp/Projects/usd_160409/xcbuild/usd_prereq_osx/qpaintengine_mac.cpp src/gui/painting/qpaintengine_mac.cpp
make -j 4; make install
sudo cp bin/qmake /usr/local/bin/
cd ${ROOT}
