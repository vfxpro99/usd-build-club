#!/bin/bash -x

DIR="$(dirname ${BASH_SOURCE[0]})"

# We use brew to get standard stuff we don't want/need to build
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
mkdir -p ~/Library/Python/2.7/lib/python/site-packages
echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth

brew update
brew upgrade

sudo easy_install -U pip
sudo pip install --upgrade PyOpenGL PyOpenGL-accelerate
sudo pip install --upgrade jinja2

brew install cmake
brew install cartr/qt4/qt              # this is a patched Qt4 which works on Sierra
brew install cartr/qt4/pyside
brew install cartr/qt4/pyside-tools
brew install boost
brew install boost-python
brew install tbb
brew install double-conversion
brew install glew
brew install openexr
brew install homebrew/versions/glfw3
brew install ptex
brew install opencolorio
brew install homebrew/science/openimageio
brew install $DIR/brew/opensubdiv.rb

echo "--- Building USD ---"
git clone https://github.com/PixarAnimationStudios/USD.git
cd USD
git checkout dev
mkdir build
cd build

# for macOS we *must* build through Xcode or it won't work!
# cmake can't find OpenSubdiv unless you help it.
cmake -G "Xcode" -DOPENSUBDIV_ROOT_DIR=/usr/local/ ..
cmake --build .
sudo cmake --build . --target install
echo "--- DONE ---"
