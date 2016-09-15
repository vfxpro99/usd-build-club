
SET current=%cd%
SET builddir=%cd%\local

if not exist "prereq\build\USD" mkdir prereq\build\USD
cd prereq\build\USD

REM // USE_PTEX=0 because ptex integration is currently broken with the latest version of ptex
cmake ..\..\..\..\USD ^
      -DPXR_BUILD_MAYA_PLUGIN=0 ^
      -DPXR_BUILD_KATANA_PLUGIN=0 ^
      -DCMAKE_INSTALL_PREFIX="%builddir%" ^
      -DCMAKE_PREFIX_PATH="%builddir%" ^
      -DALEMBIC_DIR="%builddir%" ^
      -DDOUBLE_CONVERSION_DIR="%builddir%" ^
      -DGLEW_LOCATION="%builddir%" ^
      -DOIIO_LOCATION="%builddir%" ^
      -DOPENEXR_ROOT_DIR="%builddir%" ^
      -DOPENSUBDIV_ROOT_DIR="%builddir%" ^
      -DQT_ROOT_DIR="%builddir%" ^
      -DTBB_ROOT_DIR="%builddir%" ^
      -DBoost_INCLUDE_DIR="%builddir%"/include -DBoost_LIBRARY_DIR="%builddir%"/lib ^
      -DPXR_INSTALL_LOCATION="%builddir%" ^
      -DPTEX_LOCATION="%builddir%" ^
      -DUSE_PTEX=0 ^
      -G "Visual Studio 14 2015 Win64"
