#!/bin/bash

# requires Qt 4.8.7

sudo pip install -U PySide

# repair PySide installation

sudo install_name_tool -change @rpath/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libpyside-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtCore.so 

sudo install_name_tool -change @rpath/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/QtCore.so 

sudo install_name_tool -change @rpath/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libshiboken-python2.7.1.2.dylib \
                               /Library/Python/2.7/site-packages/PySide/libpyside-python2.7.1.2.dylib
