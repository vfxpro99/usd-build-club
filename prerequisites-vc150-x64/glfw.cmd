ECHO building glfw

SET current=%cd%

if not exist "prereq" mkdir prereq
cd prereq

if not exist "glfw\CMakeLists.txt" ^
git clone https://github.com/glfw/glfw.git

cd glfw
git pull
cd ..

if not exist "build\glfw" mkdir build\glfw
cd build\glfw

cmake -G "Visual Studio 15 2017 Win64"^
      -DCMAKE_PREFIX_PATH="%current%\local"^
      -DCMAKE_INSTALL_PREFIX="%current%\local"^
       ..\..\glfw

cmake --build . --target install --config Release -- /maxcpucount:16

cd %current%
