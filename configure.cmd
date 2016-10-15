
SET current=%cd%
SET builddir=%cd%\local

if not exist "prereq\build\USD" mkdir prereq\build\USD
cd prereq\build\USD

REM // USE_PTEX=0 because ptex integration is currently broken with the latest version of ptex
cmake ..\..\..\..\USD ^
      -DPXR_BUILD_MAYA_PLUGIN=0 ^
      -DPXR_BUILD_KATANA_PLUGIN=0 ^
      -DPXR_BUILD_ALEMBIC_PLUGIN=0 ^
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
      -DTBB_ROOT_DIR="%builddir%" ^
      -DQt5Core_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Core" ^
      -DQt5Gui_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Gui" ^
      -DQt5OpenGL_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5OpenGL" ^
      -DQt5Network_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Network" ^
      -DQt5Xml_DIR="C:\qt\5.7\msvc2015_64\lib\cmake\Qt5Xml" ^
      -DPYSIDE_BIN_DIR="C:\Python27\Scripts" ^
      -DBoost_INCLUDE_DIR="%builddir%"/include -DBoost_LIBRARY_DIR="%builddir%"/lib ^
      -DPXR_INSTALL_LOCATION="%builddir%" ^
      -DPTEX_LOCATION="%builddir%" ^
      -G "Visual Studio 14 2015 Win64"
