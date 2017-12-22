# This file is just an orchestration
cmake_minimum_required(VERSION 3.8.2)
project(swig_template VERSION 1.0 LANGUAGES NONE)

include(CTest)
set(CMAKE_VERBOSE_MAKEFILE ON)
if(UNIX)
	cmake_policy(SET CMP0068 NEW)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  option(BUILD_SHARED_LIBS "Build shared libraries(.so)." ON)
else()
 set(BUILD_SHARED_LIBS OFF)
endif()

add_subdirectory(Foo)
add_subdirectory(Bar)
add_subdirectory(FooBar)

# Setup Python
# Specify python version
set(Python_ADDITIONAL_VERSIONS "3.6;3.5;2.7")
find_package(PythonInterp REQUIRED)
set(Python_ADDITIONAL_VERSIONS ${PYTHON_VERSION_STRING})

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
	COMMAND ${CMAKE_COMMAND} -E echo "  'Foo':['$<TARGET_FILE:Foo>','$<TARGET_FILE:_pyFoo>']," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'Bar':['$<TARGET_FILE:Bar>','$<TARGET_FILE:_pyBar>']," >> setup.py
	COMMAND ${CMAKE_COMMAND} -E echo "  'FooBar':['$<TARGET_FILE:FooBar>','$<TARGET_FILE:_pyFooBar>']," >> setup.py
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

add_custom_target(bdist
	DEPENDS setup.py
  COMMAND ${PYTHON_EXECUTABLE} setup.py bdist
	)

# TEST
# Testing using a vitual environment
if (BUILD_TESTING)
	find_program(VENV_EXECUTABLE virtualenv)
	if (NOT VENV_EXECUTABLE)
		message(FATAL_ERROR "Could not find virtualenv")
	else()
		message(STATUS "Found virtualenv: ${VENV_EXECUTABLE}")
	endif()

	set(VENV_DIR ${CMAKE_BINARY_DIR}/venv)
	if (WIN32)
		set(VENV_BIN_DIR ${VENV_DIR}/Scripts)
    else()
			set(VENV_BIN_DIR ${VENV_DIR}/bin)
    endif()

    # make a virtualenv to install our python package in it
		add_custom_command(
			OUTPUT ${VENV_DIR}
			DEPENDS bdist
			COMMAND ${VENV_EXECUTABLE} -p ${PYTHON_EXECUTABLE} ${VENV_DIR}
			COMMAND ${VENV_BIN_DIR}/python setup.py install
			WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
		add_custom_target(testenv DEPENDS ${VENV_DIR})
		# Let wrap this target in a test (see below)
		add_test(build_venv "${CMAKE_COMMAND}"
			--build ${CMAKE_BINARY_DIR}
			--target testenv)

    # run the tests within the virtualenv
    add_test(pytest_venv	${VENV_BIN_DIR}/python ${CMAKE_CURRENT_SOURCE_DIR}/test.py)
		# A test can only depends on another test not a target...
		set_tests_properties(pytest_venv PROPERTIES DEPENDS build_venv)
endif()

# Testing using CMAKE_BINARY_DIR
if (BUILD_TESTING)
	add_custom_target(pyAll DEPENDS _pyFoo _pyBar _pyFooBar)
		# Let wrap this target in a test (see below)
		add_test(pyAll "${CMAKE_COMMAND}"
			--build ${CMAKE_BINARY_DIR}
			--target pyAll )

    # run the tests within the virtualenv
    add_test(pytest	${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test.py)
		set_tests_properties(pytest PROPERTIES ENVIRONMENT "PYTHONPATH=${CMAKE_BINARY_DIR}")
		# A test can only depends on another test not a target...
		set_tests_properties(pytest_venv PROPERTIES DEPENDS pyAll)
endif()
