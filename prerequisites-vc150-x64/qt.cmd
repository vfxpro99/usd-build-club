ECHO building Qt
rem note that Qt's build system assumes no spaces in file names, so put the source in
rem c:\Qt\qt-everywhere-blah in order to avoid this bug
rem Qt 4.8.6 isn't compatible with msvc2015, so qt 4.8.7 is necessary.
rem this configure command is all on one line because when split up, it seems not to work properly

rem Qt 4.8.7 can be obtained from here - https://download.qt.io/official_releases/qt/4.8/4.8.7/

.\configure.exe -make nmake -platform win64-msvc2017 -prefix c:\Qt\5.10.0\msvc2017 -opensource -confirm-license -opengl desktop -nomake examples -nomake demos -nomake tests -nomake translations -no-phonon -no-multimedia -no-qt3support -shared -stl

nmake

echo Before continuing, update your PATH variable to have the newly generated qmake in it.
echo Cmake will fail to detect Qt without it.
