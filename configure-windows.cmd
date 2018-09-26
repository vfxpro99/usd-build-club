
SET f=%cd%
set "current=%f:\=/%"

SET builddir=%current%/local

if not exist "build\USD" mkdir build\USD
cd build\USD

set tbb_lib="tbb.lib"
if "%~1"=="debug" (set tbb_debug="-DTBB_USE_DEBUG_BUILD:INT=1")
if "%~1"=="debug" (set tbb_lib="tbb_debug.lib")
if "%~1"=="Debug" (set tbb_debug="-DTBB_USE_DEBUG_BUILD:INT=1")
if "%~1"=="Debug" (set tbb_lib="tbb_debug.lib")

echo "configuring for %tbb_debug% *******"

REM Pixar's suggested values, different than build-club's
REM    -DOPENEXR_LOCATION=C:\path\to\openexr        ^
REM    -DPTEX_INCLUDE_DIR=C:\path\to\ptex           ^
REM    -DOIIO_BASE_DIR=C:\path\to\openimageio       ^
REM    -DBOOST_ROOT=C:\path\to\boost                ^

cmake ..\..\..\USD ^
      -G "Visual Studio 15 2017 Win64" ^
      -DPXR_VALIDATE_GENERATED_CODE=OFF ^
      -DPXR_BUILD_MAYA_PLUGIN=0 ^
      -DPXR_BUILD_KATANA_PLUGIN=0 ^
      -DPXR_BUILD_ALEMBIC_PLUGIN=1 ^
      -DPXR_ENABLE_HDF5_SUPPORT=0 ^
      -DCMAKE_INSTALL_PREFIX="%builddir%" ^
      -DCMAKE_PREFIX_PATH="%builddir%" ^
      -DALEMBIC_DIR="%builddir%" ^
      -DDOUBLE_CONVERSION_DIR="%builddir%" ^
      -DGLEW_LOCATION="%builddir%" ^
      -DOIIO_LOCATION="%builddir%" ^
      -DOPENEXR_ROOT_DIR="%builddir%" ^
      -DOPENSUBDIV_ROOT_DIR="%builddir%" ^
      -DPTEX_LOCATION="%builddir%" ^
      -DQT_ROOT_DIR="%builddir%" ^
      -DHDF5_ROOT="%builddir%" ^
      -DTBB_tbb_LIBRARY="%builddir%/lib/%tbb_lib%"         ^
      -DQt5Core_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Core" ^
      -DQt5Gui_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Gui" ^
      -DQt5OpenGL_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5OpenGL" ^
      -DQt5Network_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Network" ^
      -DQt5Xml_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Xml" ^
      -DPYSIDE_BIN_DIR="C:\Python27\Scripts" ^
      -DBoost_INCLUDE_DIR="%builddir%/include" -DBoost_LIBRARY_DIR="%builddir%/lib" ^
      -DPXR_INSTALL_LOCATION="%builddir%"
