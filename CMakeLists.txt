# This file is just an orchestration
cmake_minimum_required(VERSION 3.9)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Apple: Don't modify install_name when touching RPATH.
if(POLICY CMP0068)
	cmake_policy(SET CMP0068 NEW)
endif()

# Force default build type to Release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
    "Choose the type of build, options are: Debug, Release (default), RelWithDebInfo and MinSizeRel."
		FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Usage find_package(TARGET_PACKAGE [PACKAGE OPTIONS]).
# e.g.: find_target(Protobuf REQUIRED)
macro(find_package TARGET_PACKAGE)
  if(TARGET CMakeSwig::${TARGET_PACKAGE})
		get_target_property(TGT_VERSION CMakeSwig::${TARGET_PACKAGE} VERSION)
		message(STATUS "Found Target: CMakeSwig::${TARGET_PACKAGE} (found version \"${TGT_VERSION}\")")
    set(${TARGET_PACKAGE}_FOUND TRUE PARENT_SCOPE)
	else()
		find_package(${TARGET_PACKAGE} ${ARGN})
	endif()
endmacro()

project(meta VERSION 1.0 LANGUAGES NONE)

include(CTest)
set(CMAKE_VERBOSE_MAKEFILE ON)
if(UNIX)
	set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
	option(BUILD_SHARED_LIBS "Build shared libraries(.so or .dyld)." ON)
else()
	# Only support static build for windows
  # ToDo: Play with dll import/export
 set(BUILD_SHARED_LIBS OFF)
 # build swig
 include(swig)
endif()

# Setup Python
set(Python_ADDITIONAL_VERSIONS "3.7;3.6;3.5;2.7" CACHE STRING "Python to use for binding")
find_package(PythonInterp REQUIRED)
# Force PythonLibs to find the same version than the python interpreter.
set(Python_ADDITIONAL_VERSIONS "${PYTHON_VERSION_STRING}")
# PythonLibs require enable_language(CXX)
enable_language(CXX)
find_package(PythonLibs REQUIRED)

add_subdirectory(Foo)
add_subdirectory(Bar)
add_subdirectory(FooBar)

#######################
## Python Packaging  ##
#######################
configure_file(cmake/__init__.py.in Foo/__init__.py COPYONLY)
configure_file(cmake/__init__.py.in Bar/__init__.py COPYONLY)
configure_file(cmake/__init__.py.in FooBar/__init__.py COPYONLY)

# To use a cmake generator expression (aka $<>), it must be processed at build time
# i.e. inside a add_custom_command()
# This command will depend on TARGET(s) in cmake generator expression
add_custom_command(OUTPUT setup.py dist ${PROJECT_NAME}.egg-info
	COMMAND ${CMAKE_COMMAND} -E echo "from setuptools import dist, find_packages, setup" > setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "class BinaryDistribution(dist.Distribution):" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  def is_pure(self):" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "    return False" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  def has_ext_modules(self):" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "    return True" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "setup(" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  name='${PROJECT_NAME}'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  version='${PROJECT_VERSION}'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  author='Mizux'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  distclass=BinaryDistribution," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  packages=find_packages()," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  package_data={" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Foo':['$<TARGET_FILE_NAME:Foo>','$<TARGET_FILE_NAME:_pyFoo>']," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Bar':['$<TARGET_FILE_NAME:Bar>','$<TARGET_FILE_NAME:_pyBar>']," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'FooBar':['$<TARGET_FILE_NAME:FooBar>','$<TARGET_FILE_NAME:_pyFooBar>']," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  }," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  include_package_data=True," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  classifiers=[" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Development Status :: 5 - Production/Stable'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Intended Audience :: Developers'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'License :: OSI Approved :: Apache Software License'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Operating System :: POSIX :: Linux'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Operating System :: MacOS :: MacOS X'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Operating System :: Microsoft :: Windows'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Programming Language :: Python'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Programming Language :: C++'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Topic :: Scientific/Engineering'," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Topic :: Software Development ::	Libraries :: Python Modules'" >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  ]," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo ")" >> setup.py
	VERBATIM)

function(search_python_module MODULE_NAME)
	execute_process(
		COMMAND ${PYTHON_EXECUTABLE} -c "import ${MODULE_NAME}; print(${MODULE_NAME}.__version__)"
		RESULT_VARIABLE _RESULT
		OUTPUT_VARIABLE MODULE_VERSION
		ERROR_QUIET
		OUTPUT_STRIP_TRAILING_WHITESPACE
		)
	if(${_RESULT} STREQUAL "0")
		message(STATUS "Found python module: ${MODULE_NAME} (found version \"${MODULE_VERSION}\")")
	else()
		message(WARNING "Can't find python module \"${MODULE_NAME}\", install it using pip...")
		execute_process(
			COMMAND ${PYTHON_EXECUTABLE} -m pip install ${MODULE_NAME}
			OUTPUT_STRIP_TRAILING_WHITESPACE
			)
	endif()
endfunction()

# Look for python module wheel
search_python_module(wheel)

add_custom_target(bdist ALL
	DEPENDS setup.py
	COMMAND ${CMAKE_COMMAND} -E remove_directory dist
	COMMAND ${PYTHON_EXECUTABLE} setup.py bdist bdist_wheel
	)

# Test
if(BUILD_TESTING)
	# Look for python module virtualenv
	search_python_module(virtualenv)
	# Testing using a vitual environment
	set(VENV_EXECUTABLE ${PYTHON_EXECUTABLE} -m virtualenv)
	set(VENV_DIR ${CMAKE_BINARY_DIR}/venv)
	if(WIN32)
		set(VENV_BIN_DIR "${VENV_DIR}\\Scripts")
	else()
		set(VENV_BIN_DIR ${VENV_DIR}/bin)
	endif()
	# make a virtualenv to install our python package in it
	add_custom_command(TARGET bdist POST_BUILD
		COMMAND ${VENV_EXECUTABLE} -p ${PYTHON_EXECUTABLE} ${VENV_DIR}
		COMMAND ${VENV_BIN_DIR}/python setup.py install
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	# run the tests within the virtualenv
	add_test(pytest_venv ${VENV_BIN_DIR}/python ${CMAKE_CURRENT_SOURCE_DIR}/cmake/test.py)
endif()

# Install
include(GNUInstallDirs)
install(EXPORT CMakeSwigTargets
	NAMESPACE CMakeSwig::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig
	COMPONENT Devel)
include(CMakePackageConfigHelpers)
configure_package_config_file(cmake/CMakeSwigConfig.cmake.in
	"${PROJECT_BINARY_DIR}/CMakeSwigConfig.cmake"
	INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig"
	NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_file(
	"${PROJECT_BINARY_DIR}/CMakeSwigConfigVersion.cmake"
	COMPATIBILITY SameMajorVersion)
install(
	FILES
	"${PROJECT_BINARY_DIR}/CMakeSwigConfig.cmake"
	"${PROJECT_BINARY_DIR}/CMakeSwigConfigVersion.cmake"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig"
	COMPONENT Devel)
