# Setup SWIG
find_package(SWIG REQUIRED)
include(UseSWIG)

# Setup Python
find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)

# include path for swig foobar.i 'target'
include_directories(../include)
set_property(SOURCE foobar.i PROPERTY CPLUSPLUS ON)
# outdir for .py file
set(CMAKE_SWIG_OUTDIR ${CMAKE_CURRENT_BINARY_DIR}/..)
# outdir for .so file
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/..)
# this will generate pyFooBar.py AND _%module%.so
swig_add_library(pyFooBar
	TYPE SHARED
	LANGUAGE python
	SOURCES	foobar.i)

# ${SWIG_MODULE_py${PROJECT_NAME}_REAL_NAME} will resolve to _pyFooBar.so TARGET
target_include_directories(${SWIG_MODULE_pyFooBar_REAL_NAME} PRIVATE
	${PYTHON_INCLUDE_DIRS})
target_link_libraries(${SWIG_MODULE_pyFooBar_REAL_NAME} PRIVATE
	FooBar ${PYTHON_LIBRARIES})
if(UNIX)
	if(NOT APPLE)
		set_target_properties(${SWIG_MODULE_pyFooBar_REAL_NAME} PROPERTIES
			INSTALL_RPATH	"$ORIGIN")
	else()
		set_target_properties(${SWIG_MODULE_pyFooBar_REAL_NAME} PROPERTIES
			SUFFIX ".so"
			INSTALL_RPATH	"@loader_path")
		set_property(TARGET ${SWIG_MODULE_pyFooBar_REAL_NAME} APPEND PROPERTY
			LINK_FLAGS "-flat_namespace -undefined suppress")
	endif()
endif()
