
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
  ..\usd-build-club\build-windows.cmd
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


Building USD on macOS using Homebrew
------------------------------------

Building USD this way will use brew to create all the libraries
USD depends on into /usr/local and will build USD there itself.

Pick this method if you want USD tools to be available from the
command line, and it's fine if everything is mingled into /usr.

Use homebrew with caution.

Please be aware that brew installs many things globally, which can
really confuse cmake. For example, consider a case where brew has
installed Field3d, but your local build environment does not include
Field3d. If you subsequently try to build OpenImageIO in your local
build environment, cmake will discover the global Field3d and link it.
At this point, the boost rpaths will become cross linked between brew's
global boost, and your local boost if you have one. This can cause
absolute havoc if versions differ. Boost, glew, tbb, and more are all
subject to this inadvertent behavior.

```
mkdir Projects
cd Projects
git clone https://github.com/vfxpro99/usd-build-club.git
./usd-build-club/build-macos-brew.sh
```


Building USD on macOS for Maya
------------------------------

Building USD on macOS for Maya is only supported for Maya 2017.
Obtain the Maya 2017 devkit, and copy the contents of the downloaded DMG file
to /Applications/Autodesk/maya2017, replacing the folders that are already there.


```
  cd ~/Library;mkdir Pixar;cd Pixar
  git clone https://github.com/PixarAnimationStudios/USD.git
  cd USD
  git checkout dev
```

Apply the following patch by saving it in to the USD root directory as FindMaya.patch, then
```
git apply FindMaya.patch
```

```

From 011a6d30f33b07178f9b78431764027e7c3febc7 Mon Sep 17 00:00:00 2001
From: vfxpro99 <vfxpro99@gmail.com>
Date: Fri, 18 Nov 2016 17:29:45 -0800
Subject: [PATCH] Patch for Maya detection

---
 cmake/modules/FindMaya.cmake | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/cmake/modules/FindMaya.cmake b/cmake/modules/FindMaya.cmake
index 0a742be..e07d6ca 100644
--- a/cmake/modules/FindMaya.cmake
+++ b/cmake/modules/FindMaya.cmake
@@ -29,18 +29,11 @@
 if(APPLE)
     find_path(MAYA_BASE_DIR
             ../../devkit/include/maya/MFn.h
+            include/maya/MFn.h
         HINTS
             "${MAYA_LOCATION}"
             "$ENV{MAYA_LOCATION}"
             "/Applications/Autodesk/maya2017/Maya.app/Contents"
-            "/Applications/Autodesk/maya2015/Maya.app/Contents"
-            "/Applications/Autodesk/maya2014/Maya.app/Contents"
-            "/Applications/Autodesk/maya2013.5/Maya.app/Contents"
-            "/Applications/Autodesk/maya2013/Maya.app/Contents"
-            "/Applications/Autodesk/maya2012.17/Maya.app/Contents"
-            "/Applications/Autodesk/maya2012/Maya.app/Contents"
-            "/Applications/Autodesk/maya2011/Maya.app/Contents"
-            "/Applications/Autodesk/maya2010/Maya.app/Contents"
     )
     find_path(MAYA_LIBRARY_DIR libOpenMaya.dylib
         HINTS
@@ -52,6 +45,8 @@ if(APPLE)
         DOC
             "Maya's libraries path"
     )
+    set(_PXR_CXX_DEFINITIONS "${_PXR_CXX_DEFINITIONS} -DOSMac_MachO_ -DOSMac_")
+
 elseif(UNIX)
     find_path(MAYA_BASE_DIR
             include/maya/MFn.h
@@ -150,12 +145,14 @@ find_path(MAYA_LIBRARY_DIR
 list(APPEND MAYA_INCLUDE_DIRS ${MAYA_INCLUDE_DIR})

 find_path(MAYA_DEVKIT_INC_DIR
-       GL/glext.h
+       tbb/tbb.h
+
     HINTS
         "${MAYA_LOCATION}"
         "$ENV{MAYA_LOCATION}"
         "${MAYA_BASE_DIR}"
     PATH_SUFFIXES
+        include
         ../../devkit/plug-ins/
     DOC
         "Maya's devkit headers path"
@@ -184,6 +181,7 @@ foreach(MAYA_LIB
             "${MAYA_BASE_DIR}"
         PATH_SUFFIXES
             MacOS/
+            Maya.app/Contents/MacOS/
             lib/
         DOC
             "Maya's ${MAYA_LIB} library path"
@@ -192,7 +190,6 @@ foreach(MAYA_LIB
         NO_CMAKE_SYSTEM_PATH
     )

-
     if (MAYA_${MAYA_LIB}_LIBRARY)
         list(APPEND MAYA_LIBRARIES ${MAYA_${MAYA_LIB}_LIBRARY})
     endif()
--
2.8.4 (Apple Git-73)



```

Continue with the build process as follows.

```
  cd ..
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
