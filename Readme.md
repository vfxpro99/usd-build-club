
This project includes recipes to build Pixar's Universal Scene Description, it's
Python bindings, and all necessary prerequisites for:

1. macOS
2. Windows
3. Maya on macOS
4. macOS, using Homebrew

The Linux scripts are still work in progress.


Building USD on Windows
-----------------------
Note that the windows build is a work in progress, and the
branch may not yet be in a buildable state.

Prereqs:
 1. Install Python 2.7 and Pip. When using the python.msi installer, installing pip, and putting Python in %PATH% are both options that should be selected.
 1. pip install PySide
 1. pip install pyd (unclear if this is necessary or not)
 1. pip install pyopengl (required for usdview)
 1. Ensure PySide tools (in python27/scripts) are visible on %PATH%. pip probably put it there already.
 1. Install CMake and make sure its on your %PATH%
 1. Install NASM from http://www.nasm.us/. Make sure it's on your %PATH% in the working terminal
 1. Install 7-Zip, make sure 7z is on your %PATH% in the working terminal
 1. Download & unzip win-flex and bison from https://sourceforge.net/projects/winflexbison/, put them in the %PATH%.

Qt is no longer required for a build of USD, or usdview. PySide is sufficient, so the next two steps can be omitted.

 1. Download Qt via the binary installer, default install works at the time of this writing
 1. Ensure qmake.exe is on the %PATH% in the working terminal

Run the commands below in a **64-bit VS2015** Developer command prompt.

Please note that the HDF5 integer and floating point detection logic works
by failing and MSVC will pop up numerous Assertion dialogs. Thus, it's necessary
to "Ignore" and "Cancel" each and every one of them. This party game is super
annoying, and HDF5 support in Alembic is being phased out. For the moment, Alembic
is being compiled without HDF5 support.

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
  ..\usd-build-club\build-prerequisites-windows.cmd
  ..\usd-build-club\configure.cmd
  cd prereq\build\USD
  cmake --build . --target install --config Release -- /maxcpucount:16
```

For debug builds (at least currently), OpenSubdiv must be compiled in debug config (edit OpenSubdiv.cmd) and two files must be edited in the USD source directory:

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

Building USD on Windows - Experimental
--------------------------------------

Install the required programs such as python and so on as above. The *build-windows.cmd*
script takes two optional arguments: *debug* to build as Debug instead of Release,
and *prereq* to build the prerequisites before building USD itself. Note that this
batch file does not perform the modifications noted above for OpenSubdiv, and so that
step must still be peformed manually.

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
  ..\usd-build-club\build-windows.cmd prereq release
```


Building USD on macOS
---------------------

Building USD this way will create a local cache of all the libraries
USD depends on as well as USD itself.

Pick this method if you need to exercise absolute control over the
libraries and don't want to mix them in with your system paths.

Run the following in your projects directory:

```
  git clone https://github.com/PixarAnimationStudios/USD.git
  cd USD
  git checkout dev
  cd ..
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  ../usd-build-club/build-prerequisites-macos.sh
  ../usd-build-club/configure.sh Xcode
  cmake --build . --target install --config Release
```

Building USD on macOS - Experimental
------------------------------------

Building USD this way will create a local cache of all the libraries
USD depends on as well as USD itself.

Pick this method if you need to exercise absolute control over the
libraries and don't want to mix them in with your system paths.

The script will prompt for any necessary dependencies not managed
by the script itself, such as cmake.

Run the following in your project directory:

```
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  ../usd-build-club/build-macos.sh
```

Building USD on macOS using Brew
--------------------------------
Don't. The brew script is experimental, and will make it impossible to
build and run any of the DCC plugins, such as the USD Maya plugin.

Building USD on macOS for Maya
------------------------------

Building USD on macOS for Maya is only supported for Maya 2017.
Obtain the Maya 2017 devkit, and copy the contents of the downloaded DMG file
to /Applications/Autodesk/maya2017, replacing the folders that are already there.

```
  cd ~/Library;mkdir Pixar;cd Pixar
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir USD_maya
  cd USD_maya
  ../usd-build-club/build-macos-maya.sh
```

Modify Maya.env at ~/Library/Preferences/Autodesk/maya/2017/Maya.env according
to the directions at http://graphics.pixar.com/usd/docs/Maya-USD-Plugins.html.
Noting that Maya does not expand tilde for user home directory, typical settings are -

````
MAYA_PLUG_IN_PATH=$MAYA_PLUGIN_PATH:/Users/vfxpro99/Library/Pixar/USD_maya/local/third_party/maya/plugin/
MAYA_SCRIPT_PATH=$MAYA_SCRIPT_PATH:/Users/vfxpro99/Library/Pixar/USD_maya/local/third_party/maya/share/usd/plugins/usdMaya/resources/
PYTHONPATH=$PYTHONPATH:/Users/vfxpro99/Library/Pixar/USD_maya/local/lib/python/
```

Open Maya and open the Plugin manager, found at Windows > Settings/Preferences > Plugin-manager.
Click Loaded beside pxrUsd.bundle, and click Autoload if you want the plugin automatically loaded at start.
