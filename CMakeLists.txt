# This file is just an orchestration
cmake_minimum_required(VERSION 3.20)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Enable output of compile commands during generation.
option(CMAKE_EXPORT_COMPILE_COMMANDS "Export compile command" ON)

project(CMakeSwig VERSION 1.0 LANGUAGES CXX)
set(PROJECT_NAMESPACE cs)
message(STATUS "${PROJECT_NAME} version: ${PROJECT_VERSION}")
#message(STATUS "major: ${PROJECT_VERSION_MAJOR}")
#message(STATUS "minor: ${PROJECT_VERSION_MINOR}")
#message(STATUS "patch: ${PROJECT_VERSION_PATCH}")

# Default Build Type to be Release
get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(isMultiConfig)
  if(NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES "Release;Debug" CACHE STRING
    "Choose the type of builds, options are: Debug Release RelWithDebInfo MinSizeRel. (default: Release;Debug)"
    FORCE)
  endif()
  message(STATUS "Configuration types: ${CMAKE_CONFIGURATION_TYPES}")
else()
  if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
    "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel. (default: Release)"
    FORCE)
  endif()
  message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
endif()

# Layout build dir like install dir
include(GNUInstallDirs)
if(UNIX)
  option(BUILD_SHARED_LIBS "Build shared libraries (.so or .dylib)." ON)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  # for multi-config build system (e.g. Xcode, Ninja Multi-Config)
  foreach(OutputConfig IN LISTS CMAKE_CONFIGURATION_TYPES)
    string(TOUPPER ${OutputConfig} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_LIBDIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_LIBDIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
  endforeach()
else()
  # Currently Only support static build for windows
  option(BUILD_SHARED_LIBS "Build shared libraries (.dll)." OFF)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
  # for multi-config builds (e.g. msvc)
  foreach(OutputConfig IN LISTS CMAKE_CONFIGURATION_TYPES)
    string(TOUPPER ${OutputConfig} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
  endforeach()
endif()

if(MSVC AND BUILD_SHARED_LIBS)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

# Disable CTest targets
set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)
include(CTest)

# By default only the CMakeSwig C++ library is built.
option(BUILD_CXX "Build C++ library" ON)
message(STATUS "Build C++ library: ${BUILD_CXX}")

option(BUILD_PYTHON "Build Python Library" OFF)
message(STATUS "Build Python: ${BUILD_PYTHON}")
option(BUILD_JAVA "Build Java Library" OFF)
message(STATUS "Build Java: ${BUILD_JAVA}")
option(BUILD_DOTNET "Build .NET Library" OFF)
message(STATUS "Build .Net: ${BUILD_DOTNET}")

include(cpp)

if(WIN32 AND (BUILD_DOTNET OR BUILD_JAVA OR BUILD_PYTHON))
  message(STATUS "Getting SWIG: ...")
  include(swig)
  message(STATUS "Getting SWIG: ...DONE")
endif()

if(BUILD_DOTNET)
  # Language Version
  # see: https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/configure-language-version
  set(DOTNET_LANG "9.0" CACHE STRING "Specify the C# language version (default \"9.0\")")
  message(STATUS ".Net C# language version: ${DOTNET_LANG}")

  set(DOTNET_SAMPLE_LANG "8.0" CACHE STRING "Specify the C# language version for samples (default \"8.0\")")
  message(STATUS ".Net Samples C# language version: ${DOTNET_SAMPLE_LANG}")

  # Targeted Framework Moniker
  # see: https://docs.microsoft.com/en-us/dotnet/standard/frameworks
  # see: https://learn.microsoft.com/en-us/dotnet/standard/net-standard
  # .Net Core 3.1 LTS is not available for osx arm64
  if(APPLE AND CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)")
    set(USE_DOTNET_CORE_31 OFF)
  else()
    option(USE_DOTNET_CORE_31 "Use .Net Core 3.1 LTS support" OFF)
  endif()
  message(STATUS ".Net: Use .Net Core 3.1 LTS support: ${USE_DOTNET_CORE_31}")

  option(USE_DOTNET_6 "Use .Net 6.0 LTS support" OFF)
  message(STATUS ".Net: Use .Net 6.0 LTS support: ${USE_DOTNET_6}")

  option(USE_DOTNET_7 "Use .Net 7.0 support" OFF)
  message(STATUS ".Net: Use .Net 7.0 support: ${USE_DOTNET_7}")

  option(USE_DOTNET_8 "Use .Net 8.0 LTS support" ON)
  message(STATUS ".Net: Use .Net 8.0 support: ${USE_DOTNET_8}")

  option(USE_DOTNET_9 "Use .Net 9.0 support" OFF)
  message(STATUS ".Net: Use .Net 9.0 support: ${USE_DOTNET_9}")
endif()
include(dotnet)

if(BUILD_JAVA)
  option(SKIP_GPG "Disable GPG sign" ON)
  message(STATUS "Java: Disable gpg:sign: ${SKIP_GPG}")
endif()
include(java)

if(BUILD_PYTHON)
  CMAKE_DEPENDENT_OPTION(BUILD_VENV "Create Python venv in BINARY_DIR/python/venv" OFF
    "NOT BUILD_TESTING" ON)
  message(STATUS "Python: Create venv: ${BUILD_VENV}")

  CMAKE_DEPENDENT_OPTION(VENV_USE_SYSTEM_SITE_PACKAGES "Python venv can use system site packages" OFF
    "BUILD_VENV" OFF)
  message(STATUS "Python: Allow venv to use system site packages: ${VENV_USE_SYSTEM_SITE_PACKAGES}")

  option(FETCH_PYTHON_DEPS "Install python required modules if not available" ON)
  message(STATUS "Python: Fetch dependencies: ${FETCH_PYTHON_DEPS}")
endif()
include(python)

add_subdirectory(tests)

option(BUILD_EXAMPLES "Build examples" ON)
message(STATUS "Build examples: ${BUILD_EXAMPLES}")
add_subdirectory(examples)
