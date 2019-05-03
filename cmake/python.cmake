if(NOT BUILD_PYTHON)
  return()
endif()

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR "Python: missing FooBar TARGET")
endif()

# Will need swig
find_package(SWIG REQUIRED)
include(UseSWIG)

# Find Python Interpreter
# prefer Python 3.7 over 3.6 over ...
# user can overwrite it e.g.:
# cmake -H. -Bbuild -DBUILD_PYTHON=ON -DPython_ADDITIONAL_VERSIONS="2.7"
set(Python_ADDITIONAL_VERSIONS "3.7;3.6;3.5;2.7" CACHE STRING "Python to use for binding")
find_package(PythonInterp REQUIRED)
message(STATUS "Found Python: ${PYTHON_EXECUTABLE} (found version \"${PYTHON_VERSION_STRING}\")")

# Find Python Library
# Force PythonLibs to find the same version than the python interpreter (or nothing).
set(Python_ADDITIONAL_VERSIONS "${PYTHON_VERSION_STRING}")
find_package(PythonLibs REQUIRED)
message(STATUS "Found Python Include: ${PYTHON_INCLUDE_DIRS} (found version \"${PYTHONLIBS_VERSION_STRING}\")")

# Find if python module MODULE_NAME is available, if not install it to the Python user install
# directory.
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
		message(WARNING "Can't find python module \"${MODULE_NAME}\", user install it using pip...")
		execute_process(
			COMMAND ${PYTHON_EXECUTABLE} -m pip install --upgrade --user ${MODULE_NAME}
			OUTPUT_STRIP_TRAILING_WHITESPACE
			)
	endif()
endfunction()

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
  COMMAND ${CMAKE_COMMAND} -E echo "from setuptools.command.install import install" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "class InstallPlatlib(install):" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "    def finalize_options(self):" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "        install.finalize_options(self)" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "        self.install_lib=self.install_platlib" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "setup(" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  name='${PROJECT_NAME}'," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  version='${PROJECT_VERSION}'," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  author='Mizux'," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  distclass=BinaryDistribution," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  packages=find_packages()," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  package_data={" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}':[$<$<NOT:$<PLATFORM_ID:Windows>>:'.libs/*']," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}.Foo':['$<TARGET_FILE_NAME:Foo>','$<TARGET_FILE_NAME:_pyFoo>']," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}.Bar':['$<TARGET_FILE_NAME:Bar>','$<TARGET_FILE_NAME:_pyBar>']," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}.FooBar':['$<TARGET_FILE_NAME:FooBar>','$<TARGET_FILE_NAME:_pyFooBar>']," >> setup.py
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
  COMMAND ${CMAKE_COMMAND} -E echo "  'Topic :: Software Development :: Libraries :: Python Modules'" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  ]," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo ")" >> setup.py
  VERBATIM)

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

