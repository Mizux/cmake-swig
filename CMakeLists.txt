# This file is just an orchestration
cmake_minimum_required(VERSION 3.5)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Apple: Don't modify install_name when touching RPATH.
if(POLICY CMP0068)
  cmake_policy(SET CMP0068 NEW)
endif()

project(CMakeSwig VERSION 1.0 LANGUAGES NONE)

include(util) # Overload of find_package
set(CMAKE_VERBOSE_MAKEFILE ON)

# Force default build type to Release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
    "Choose the type of build, options are: Debug, Release (default), RelWithDebInfo and MinSizeRel."
    FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Layout build dir like install dir
include(GNUInstallDirs)
if(UNIX)
  option(BUILD_SHARED_LIBS "Build shared libraries(.so or .dyld)." ON)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  # for multi-config builds (e.g. msvc,xcode)
  foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/lib)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
  endforeach()
else()
  set(BUILD_SHARED_LIBS OFF)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  # for multi-config builds (e.g. msvc,xcode)
  foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
  endforeach()
  # Currently Only support static build for windows
  include(swig)
endif()

# By default all wrappers are disabled
option(BUILD_PYTHON "Build Python Package" OFF)
if(BUILD_PYTHON)
  include(python)
endif()
option(BUILD_DOTNET "Build .Net Package" OFF)
if(BUILD_DOTNET)
  include(dotnet)
endif()
option(BUILD_DOTNET "Build Java Package" OFF)
if(BUILD_JAVA)
  include(java)
endif()

include(CTest)
add_subdirectory(Foo)
add_subdirectory(Bar)
add_subdirectory(FooBar)
add_subdirectory(FooBarApp)

if(BUILD_PYTHON)
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
endif()

# Install
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
