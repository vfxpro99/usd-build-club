#! /bin/sh
ROOT=$(pwd)
cd prereq

if [ ! -d Jinja2-2.8 ]; then
  curl -L -o jinja2.tgz https://pypi.python.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz#md5=edb51693fe22c53cee5403775c71a99e
  gunzip jinja2.tgz
  tar -xf jinja2.tar
  rm jinja2.tar
fi
cd Jinja2-2.8
sudo python setup.py install
cd ${ROOT}

