cmake_minimum_required(VERSION 3.8.2)

# Setup SWIG
find_package(SWIG REQUIRED)
include(UseSWIG)

# Setup Python
find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)

# include path for swig foo.i 'target'
include_directories(../include)
set_property(SOURCE foo.i PROPERTY CPLUSPLUS ON)
# outdir for .py file
set(CMAKE_SWIG_OUTDIR ${CMAKE_CURRENT_BINARY_DIR}/..)
# outdir for .so file
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/..)
# this will generate pyFoo.py AND _%module%.so
swig_add_library(pyFoo
	TYPE SHARED
	LANGUAGE python
	SOURCES	foo.i)

# ${SWIG_MODULE_pyFoo_REAL_NAME} will resolve to _pyFoo.so TARGET
target_include_directories(${SWIG_MODULE_pyFoo_REAL_NAME} PRIVATE
	${PYTHON_INCLUDE_DIRS})
target_link_libraries(${SWIG_MODULE_pyFoo_REAL_NAME} PRIVATE
	Foo ${PYTHON_LIBRARY})
if(UNIX)
	if(NOT APPLE)
		set_target_properties(${SWIG_MODULE_pyFoo_REAL_NAME} PROPERTIES
			INSTALL_RPATH	"$ORIGIN")
	else()
		set_target_properties(${SWIG_MODULE_pyFoo_REAL_NAME} PROPERTIES
			SUFFIX ".so"
			INSTALL_RPATH	"@loader_path")
		set_property(TARGET ${SWIG_MODULE_pyFoo_REAL_NAME} APPEND PROPERTY
			LINK_FLAGS "-flat_namespace -undefined suppress")
	endif()
endif()
