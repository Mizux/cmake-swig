if(NOT BUILD_PYTHON)
  return()
endif()

# Use latest UseSWIG module
cmake_minimum_required(VERSION 3.14)

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR "Python: missing FooBar TARGET")
endif()

# Will need swig
find_package(SWIG REQUIRED)
include(UseSWIG)

if(${SWIG_VERSION} VERSION_GREATER_EQUAL 4)
  list(APPEND CMAKE_SWIG_FLAGS "-doxygen")
endif()

if(UNIX AND NOT APPLE)
  list(APPEND CMAKE_SWIG_FLAGS "-DSWIGWORDSIZE64")
endif()

# Find Python Interpreter
# prefer Python 3.8 over 3.7 over ...
# user can overwrite it e.g.:
# cmake -S. -Bbuild -DBUILD_PYTHON=ON -DPython_ADDITIONAL_VERSIONS="3.6"
set(Python_ADDITIONAL_VERSIONS "3.8;3.7;3.6;3.5;2.7" CACHE STRING "Python to use for binding")
find_package(PythonInterp REQUIRED)
message(STATUS "Found Python: ${PYTHON_EXECUTABLE} (found version \"${PYTHON_VERSION_STRING}\")")

if(${PYTHON_VERSION_STRING} VERSION_GREATER_EQUAL 3)
  list(APPEND CMAKE_SWIG_FLAGS "-py3")
endif()

# Find Python Library
# Force PythonLibs to find the same version than the python interpreter (or nothing).
set(Python_ADDITIONAL_VERSIONS "${PYTHON_VERSION_STRING}")
find_package(PythonLibs REQUIRED)
message(STATUS "Found Python Include: ${PYTHON_INCLUDE_DIRS} (found version \"${PYTHONLIBS_VERSION_STRING}\")")

# Swig wrap all libraries
foreach(SUBPROJECT IN ITEMS Foo Bar FooBar)
  add_subdirectory(${SUBPROJECT}/python)
endforeach()

#######################
## Python Packaging  ##
#######################
# To use a cmake generator expression (aka $<>), it must be processed at build time
# i.e. inside a add_custom_command()
# This command will depend on TARGET(s) in cmake generator expression
add_custom_command(OUTPUT
  python/setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "from setuptools import find_packages, setup" > setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "from setuptools.dist import Distribution" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "class BinaryDistribution(Distribution):" >> setup.py
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
  COMMAND ${CMAKE_COMMAND} -E echo "  author_email='\"Mizux Seiha\" <mizux.dev@gmail.com>'," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  url='https://github.com/Mizux/cmake-swig'," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  distclass=BinaryDistribution," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  cmdclass={'install': InstallPlatlib}," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  packages=find_packages()," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  package_data={" >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}':[$<$<NOT:$<PLATFORM_ID:Windows>>:'.libs/*'>]," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}.Foo':['$<TARGET_FILE_NAME:pyFoo>']," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}.Bar':['$<TARGET_FILE_NAME:pyBar>']," >> setup.py
  COMMAND ${CMAKE_COMMAND} -E echo "  '${PROJECT_NAME}.FooBar':['$<TARGET_FILE_NAME:pyFooBar>']," >> setup.py
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
  COMMENT "Generate setup.py at build time (to use generator expression)"
  WORKING_DIRECTORY python
  VERBATIM)

# Find if python module MODULE_NAME is available,
# if not install it to the Python user install directory.
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

# Look for required python modules
search_python_module(setuptools)
search_python_module(wheel)

add_custom_target(python_package ALL
  DEPENDS python/setup.py
  COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/python/__init__.py.in ${PROJECT_NAME}/__init__.py
  COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/python/__init__.py.in ${PROJECT_NAME}/Foo/__init__.py
  COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/python/__init__.py.in ${PROJECT_NAME}/Bar/__init__.py
  COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/python/__init__.py.in ${PROJECT_NAME}/FooBar/__init__.py

  COMMAND ${CMAKE_COMMAND} -E remove_directory dist
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_NAME}/.libs
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:pyFoo> ${PROJECT_NAME}/Foo
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:pyBar> ${PROJECT_NAME}/Bar
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:pyFooBar> ${PROJECT_NAME}/FooBar
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:Foo> $<TARGET_FILE:Bar> $<TARGET_FILE:FooBar> ${PROJECT_NAME}/.libs
  #COMMAND ${PYTHON_EXECUTABLE} setup.py bdist_egg bdist_wheel
  COMMAND ${PYTHON_EXECUTABLE} setup.py bdist_wheel
  BYPRODUCTS
  python/${PROJECT_NAME}
  python/build
  python/dist
  python/${PROJECT_NAME}.egg-info
  WORKING_DIRECTORY python
  )

# Test
if(BUILD_TESTING)
  # Look for python module virtualenv
  search_python_module(virtualenv)
  # Testing using a vitual environment
  set(VENV_EXECUTABLE ${PYTHON_EXECUTABLE} -m virtualenv)
  set(VENV_DIR ${CMAKE_CURRENT_BINARY_DIR}/venv)
  if(WIN32)
    set(VENV_PYTHON_EXECUTABLE "${VENV_DIR}\\Scripts\\python.exe")
  else()
    set(VENV_PYTHON_EXECUTABLE ${VENV_DIR}/bin/python)
  endif()
  # make a virtualenv to install our python package in it
  add_custom_command(TARGET python_package POST_BUILD
    COMMAND ${VENV_EXECUTABLE} -p ${PYTHON_EXECUTABLE} ${VENV_DIR}
    # Must not call it in a folder containing the setup.py otherwise pip call it
    # (i.e. "python setup.py bdist") while we want to consume the wheel package
    COMMAND ${VENV_PYTHON_EXECUTABLE} -m pip install --find-links=${CMAKE_CURRENT_BINARY_DIR}/python/dist ${PROJECT_NAME}
    BYPRODUCTS ${VENV_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  # run the tests within the virtualenv
  add_test(NAME pytest_venv
    COMMAND ${VENV_PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/python/test.py)
endif()
