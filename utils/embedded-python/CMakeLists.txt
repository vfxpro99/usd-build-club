
cmake_minimum_required(VERSION 2.8.9)

project(embeddedPython)
add_executable(embeddedPython main.cpp)

if (APPLE)
  set(PYTHON_LIBRARIES "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib")
  set(PYTHON_INCLUDE_DIR "/System/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7/")
else()
  find_package(PythonLibs 2.7 REQUIRED)
endif()

target_link_libraries(embeddedPython ${PYTHON_LIBRARIES})
target_include_directories(embeddedPython PRIVATE ${PYTHON_INCLUDE_DIR})
