SET current=%cd%
cd prereq
#git clone https://github.com/OpenImageIO/oiio.git
cd oiio
mkdir build_win
cd build_win
cmake -G "Visual Studio 14 2015 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local" ..
msbuild oiio.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd %current%
