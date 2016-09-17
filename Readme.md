
Building USD on Windows
-----------------------
Note that the windows build is a work in progress, and the 
branch may not yet be in a buildable state.

Prereqs:
 1. Install Python and Pip
 1. pip install PySide
 1. pip install pyd (unclear if this is necessary or not)
 1. pip install pyopengl (required for usdview)
 1. Ensure PySide tools (in python/scripts) are visible on %PATH%
 1. Install CMake and make sure its on your %PATH%
 1. Install NASM, make sure it's on your %PATH% in the working terminal
 1. Install 7-Zip, make sure 7z is on your %PATH% in the working terminal
 1. Download & unzip win-bison (and win-flex), no need to be on the path
 1. Download Qt via the binary installer, default install works at the time of this writing
 1. Ensure qmake.exe is on the %PATH% in the working terminal

In a **64-bit VS2015** Developer command prompt:

```
  mkdir Projects
  cd Projects
  git clone https://github.com/PixarAnimationStudios/USD.git
  cd USD
  git checkout dev_win_ip
  cd ..
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  ..\usd-build-club\prerequisites-vc140-x64\python.cmd
  ..\usd-build-club\prerequisites-vc140-x64\zlib.cmd
  ..\usd-build-club\prerequisites-vc140-x64\ptex.cmd
  ..\usd-build-club\prerequisites-vc140-x64\jpeg.cmd
  ..\usd-build-club\prerequisites-vc140-x64\png.cmd
  ..\usd-build-club\prerequisites-vc140-x64\tiff.cmd
  ..\usd-build-club\prerequisites-vc140-x64\double-conversion.cmd
  ..\usd-build-club\prerequisites-vc140-x64\boost.cmd
  ..\usd-build-club\prerequisites-vc140-x64\tbb.cmd
  ..\usd-build-club\prerequisites-vc140-x64\glew.cmd
  ..\usd-build-club\prerequisites-vc140-x64\glext.cmd
  ..\usd-build-club\prerequisites-vc140-x64\openexr.cmd
  ..\usd-build-club\prerequisites-vc140-x64\OpenSubdiv.cmd
  ..\usd-build-club\prerequisites-vc140-x64\OpenImageIO.cmd
  ..\usd-build-club\configure.cmd
  cd prereq\build\usd
  cmake --build . --target install --config Release -- /maxcpucount:16
```

For a debug build (at least currently), two files must be edited in the USD source directory:

cmake/defaults/msvcdefaults.cmake
  - uncomment add_definitions("/DTBB_USE_DEBUG=1")

cmake/defaults/Packages.cmake
  - line 45: set(TBB_USE_DEBUG_BUILD ON)

Using the install:
 1. Add [PATH TO STAGE]\local\bin to %PATH%
 1. Add [PATH TO STAGE]\local\lib to %PATH%
 1. Add [PATH TO STAGE]\local\lib\python to %PYTHONPATH%

Test the build:
 1. python> from pxr import Usd

Building USD on OSX
-------------------

```
  mkdir Projects
  cd Projects
  git clone https://github.com/PixarAnimationStudios/USD.git
  cd USD
  git checkout dev
  cd ..
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  ../usd-build-club/build_prerequisites.sh
  ../usd-build-club/configure.sh Xcode
  cmake --build . --target install --config Release
```

