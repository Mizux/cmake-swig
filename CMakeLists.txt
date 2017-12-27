# This file is just an orchestration
cmake_minimum_required(VERSION 3.9)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
		"Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel."
		FORCE)
endif(NOT CMAKE_BUILD_TYPE)
# Use find_package everywhere, no-op if it's a target
macro(find_package)
	if(NOT TARGET "${ARGV0}")
		_find_package(${ARGV})
	endif()
endmacro()
# Apple: Don't modify install_name when touching RPATH.
if(POLICY CMP0068)
	cmake_policy(SET CMP0068 NEW)
endif()

project(swig_template VERSION 1.0 LANGUAGES NONE)

include(CTest)
set(CMAKE_VERBOSE_MAKEFILE ON)
if(UNIX)
	set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
	option(BUILD_SHARED_LIBS "Build shared libraries(.so or .dyld)." ON)
else()
	# Windows only support static build.
 set(BUILD_SHARED_LIBS OFF)
 include(swig)
endif()

# Setup Python
set(Python_ADDITIONAL_VERSIONS "3.6;3.5;2.7" CACHE STRING "Python to use for binding")
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
configure_file(__init__.py.in Foo/__init__.py COPYONLY)
configure_file(__init__.py.in Bar/__init__.py COPYONLY)
configure_file(__init__.py.in FooBar/__init__.py COPYONLY)

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

add_custom_target(bdist ALL
	DEPENDS setup.py
  COMMAND ${PYTHON_EXECUTABLE} setup.py bdist
  COMMAND ${PYTHON_EXECUTABLE} setup.py bdist_wheel
	)

# Test
if(BUILD_TESTING)
  # Testing using a vitual environment
	set(VENV_EXECUTABLE ${PYTHON_EXECUTABLE} -m virtualenv)
	set(VENV_DIR ${CMAKE_BINARY_DIR}/venv)
	if (WIN32)
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
	add_test(pytest_venv ${VENV_BIN_DIR}/python ${CMAKE_CURRENT_SOURCE_DIR}/test.py)

	# Testing using CMAKE_BINARY_DIR
	add_test(pytest	${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test.py)
	set_tests_properties(pytest PROPERTIES ENVIRONMENT "PYTHONPATH=${CMAKE_BINARY_DIR}")
endif()
