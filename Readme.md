
This project includes recipes to build Pixar's Universal Scene Description, it's
Python bindings, and all necessary prerequisites for:

1. macOS
2. Windows
3. Maya on macOS
4. macOS, using Homebrew

The Linux scripts are still work in progress.

Building USD on Windows
-----------------------
Details on the [wiki](https://github.com/vfxpro99/usd-build-club/wiki/USD-on-Windows)

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

Run the following in your project directory:

```
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  ../usd-build-club/build-macos.sh
```

Building USD on macOS using Brew
--------------------------------

Building USD on macOS using Brew will install brew, USD's prerequisites,
USD, and a local copy of python in your stage directory.

```
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  ../usd-build-club/build-macos-brew.sh
```

When the build is complete, run the following within a terminal
to initialize the run time environment:

```
  cd /path/to/my/stage
  source ../usd-build-club/setvars-macos-brew.sh
```

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
