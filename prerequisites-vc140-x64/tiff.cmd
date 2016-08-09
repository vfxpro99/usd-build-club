SET current=%cd%
cd prereq
git clone https://github.com/vadz/libtiff
cd libtiff
mkdir build_win
cd build_win
cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..
msbuild tiff.sln /t:Build /p:Configuration=Release /p:Platform=x64
cd %current%
xcopy .\prereq\libtiff\build_win\libtiff\Release\tiff.* .\local\lib\ /s /y
xcopy .\prereq\libtiff\libtiff\tiff*.h .\local\include\ /s /y
