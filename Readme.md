
Building USD on Windows
-----------------------
```
  mkdir Projects
  cd Projects
  git clone https://github.com/JamieKenyonFoundry/USD.git
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  ..\usd-build-club\prerequisites-vc140-x64\zlib.cmd
  ..\usd-build-club\prerequisites-vc140-x64\ptex.cmd
  ..\usd-build-club\prerequisites-vc140-x64\jpeg.cmd
  ..\usd-build-club\prerequisites-vc140-x64\png.cmd
  ..\usd-build-club\prerequisites-vc140-x64\tiff.cmd
  ..\usd-build-club\prerequisites-vc140-x64\double-conversion.cmd
  ..\usd-build-club\prerequisites-vc140-x64\boost.cmd
  ..\usd-build-club\prerequisites-vc140-x64\tbb.cmd
  ..\usd-build-club\prerequisites-vc140-x64\glew.cmd
  ..\usd-build-club\prerequisites-vc140-x64\openexr.cmd
  ..\usd-build-club\prerequisites-vc140-x64\OpenSubdiv.cmd
  ..\usd-build-club\prerequisites-vc140-x64\OpenImageIO.cmd
  ..\usd-build-club\configure.cmd
  cd prereq\build\usd
  cmake --build . --target install --config Release
```

Building USD on OSX
-------------------

```
  mkdir Projects
  cd Projects
  git clone https://github.com/PixarAnimationStudios/USD.git
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  echo get coffee... In a little while you're going to need to enter a sudo password
  ../usd-build-club/bootstrap.sh -p -b
```

Options for bootstrap.sh:
-------------------------

Specify source directory:
  -s=/path/to/USD
  -src=/path/to/USD

Configure a debug build:
  -d --debug

Use make to build instead of Xcode:
  -m --make

Build the prerequisite libraries such as boost and so on:
  -p --prerequisites

Perform the build after configuration:
  -b --build
