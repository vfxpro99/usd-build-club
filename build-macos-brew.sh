#!/bin/bash

# optional first argument: Debug

SCRIPT_DIR="$(dirname ${BASH_SOURCE[0]})"
ROOT=$(pwd)
BREW=$ROOT/homebrew/bin/brew

echo "-------------------------------------------------"
echo "1/5 Installing brew"
echo "-------------------------------------------------"


if [ ! -f "${BREW}" ]; then
  source ${SCRIPT_DIR}/brew/brew-install.sh
fi

PATH=$ROOT/homebrew/bin:${PATH}


# We use $BREW to get standard stuff we don't want/need to build
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Home$BREW/install/master/install)"
mkdir -p ~/Library/Python/2.7/lib/python/site-packages
echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> ~/Library/Python/2.7/lib/python/site-packages/homegpth

$BREW update
$BREW upgrade

echo "-------------------------------------------------"
echo "2/5 Installing USD dependencies"
echo "-------------------------------------------------"

$BREW install cmake
$BREW install python2

sudo easy_install -U pip
sudo pip install --upgrade PyOpenGL PyOpenGL-accelerate
sudo pip install --upgrade jinja2

$BREW install cartr/qt4/qt    # patched Qt4 for Sierra
$BREW install cartr/qt4/pyside
$BREW install cartr/qt4/pyside-tools
$BREW install boost
$BREW install boost-python
$BREW install tbb
$BREW install double-conversion
$BREW install glew
$BREW install openexr
$BREW install glfw3
$BREW install ptex
$BREW install opencolorio
$BREW install brewsci/science/openimageio
$BREW install $SCRIPT_DIR/brew/opensubdiv.rb

echo "-------------------------------------------------"
echo "3/5 Getting the latest USD dev code"
echo "-------------------------------------------------"

if [ ! -f ../USD/.git/config ]; then
  cd ..
  git clone https://github.com/PixarAnimationStudios/USD.git
  cd $ROOT
fi

cd ../USD
git checkout dev

cd $ROOT
mkdir -p build
cd build

echo "-------------------------------------------------"
echo "4/5 configuring USD"
echo "-------------------------------------------------"

export PYTHONPATH=${ROOT}/homebrew/lib/python2.7/site-packages/

cmake -G "Xcode" ../../USD \
      -DOPENSUBDIV_ROOT_DIR=${ROOT}/homebrew \
      -DCMAKE_PREFIX_PATH=${ROOT}/homebrew \
      -DCMAKE_INSTALL_PATH=${ROOT}/homebrew \
      -DPYTHON_EXECUTABLE=${ROOT}/homebrew/bin/python \
      -DPYTHON_INCLUDE_DIR=${ROOT}/homebrew/Frameworks/Python.framework/Versions/2.7/include/python2.7 \
      -DPYTHON_LIBRARY=${ROOT}/homebrew/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib \
      -DPYTHON_LIBRARIES=${ROOT}/homebrew/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib

echo "-------------------------------------------------"
echo "5/5 Building and installing USD"
if [[ "$1" = "Debug" ]]; then
  echo "  Debug build in progress."
  cmake --build . --target install --config Debug
else
  echo "  Release build in progress."
  cmake --build . --target install --config Release
fi
echo "-------------------------------------------------"


cd $ROOT

echo "-------------------------------------------------"
echo "USD build complete."
echo "To initialize the environment:" 
echo "source setvars-macos-brew.sh "
echo "-------------------------------------------------"
