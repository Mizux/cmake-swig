cmake_minimum_required(VERSION 3.8.2)

# Setup SWIG
find_package(SWIG REQUIRED)
include(UseSWIG)

# Setup Python
find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)

# include path for swig bar.i 'target'
include_directories(../include)
set_property(SOURCE bar.i PROPERTY CPLUSPLUS ON)
# outdir for .py file
set(CMAKE_SWIG_OUTDIR ${CMAKE_CURRENT_BINARY_DIR}/..)
# outdir for .so file
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/..)

# this will generate pyBar.py AND _pyBar.so
swig_add_library(pyBar
	TYPE SHARED
	LANGUAGE python
	SOURCES	bar.i)

# ${SWIG_MODULE_pyBar_REAL_NAME} will resolve to _pyBar.so TARGET
target_link_libraries(${SWIG_MODULE_pyBar_REAL_NAME} PRIVATE
	Bar)
target_include_directories(${SWIG_MODULE_pyBar_REAL_NAME} PRIVATE
	${PYTHON_INCLUDE_DIRS})
