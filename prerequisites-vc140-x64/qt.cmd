
rem note that Qt's build system assumes no spaces in file names, so put the source in
rem c:\Qt\qt-everywhere-blah in order to avoid this bug
rem Qt 4.8.6 isn't compatible with msvc2015, so qt 4.8.7 is necessary.
rem this configure command is all on one line because when split up, it seems not to work properly

.\configure.exe -make nmake -platform win32-msvc2015 -prefix c:\Qt\4.8.7\msvc2015 -opensource -confirm-license -opengl desktop -nomake examples -nomake demos -nomake tests -nomake translations -no-phonon -no-multimedia -no-qt3support -shared -stl

nmake
