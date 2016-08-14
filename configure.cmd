
SET current=%cd%
SET builddir=%cd%\local

if not exist "prereq\build\USD" mkdir prereq\build\USD
cd prereq\build\USD

cmake ..\..\..\..\USD_win ^
      -DCMAKE_INSTALL_PREFIX="%builddir%" ^
      -DCMAKE_PREFIX_PATH="%builddir%" ^
      -DALEMBIC_DIR="%builddir%" ^
      -DDOUBLE_CONVERSION_DIR="%builddir%" ^
      -DGLEW_LOCATION="%builddir%" ^
      -DOIIO_LOCATION="%builddir%" ^
      -DOPENEXR_ROOT_DIR="%builddir%" ^
      -DOPENSUBDIV_ROOT_DIR="%builddir%" ^
      -DQT_ROOT_DIR="%builddir%" ^
      -DPTEX_LOCATION="%builddir%" ^
      -DTBB_ROOT_DIR="%builddir%" ^
      -DBoost_INCLUDE_DIR="%builddir%"/include -DBoost_LIBRARY_DIR="%builddir%"/lib ^
      -DPXR_INSTALL_LOCATION="%builddir%" ^
      -G "Visual Studio 14 2015 Win64"
