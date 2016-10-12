#!/bin/bash

ROOT=$(pwd)
PREREQ_SCRIPTDIR=`dirname $0`

if hash qmake 2>/dev/null; then
  echo "detected Qt"
else
  if hash ~/Qt/5.7/clang_64/bin/qmake 2>/dev/null; then
    echo -e "\n\n\nDetected qmake, adding it to the path\n\n\n"
    export PATH=~/Qt/5.7/clang_64/bin:$PATH
  else
    echo -e "\n\n\nPlease install Qt to the default location in ~/Qt. \n\nRun this pyside.sh script again after Qt has been installed.\n\n\n"
    $PREREQ_SCRIPTDIR/qt4.sh
    exit 1
  fi
fi

if hash pip 2>/dev/null; then
  echo "detected pip"
else
  sudo easy_install pip
fi

sudo -H pip install -U PySide

# repair PySide installation

sudo install_name_tool -change @rpath/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libpyside-python2.7.1.2.dylib


sudo install_name_tool -change @rpath/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtCore.so

sudo install_name_tool -change @rpath/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtGui.so

sudo install_name_tool -change @rpath/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtOpenGL.so


sudo install_name_tool -change @rpath/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtCore.so

sudo install_name_tool -change @rpath/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtGui.so

sudo install_name_tool -change @rpath/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtOpenGL.so
