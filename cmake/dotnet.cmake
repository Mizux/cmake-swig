if(NOT BUILD_DOTNET)
  return()
endif()

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR ".Net: missing FooBar TARGET")
endif()

# Will need swig
find_package(SWIG REQUIRED)
include(util)
setup_package_version_variables(SWIG)
message(STATUS "swig major: ${SWIG_VERSION_MAJOR}")
message(STATUS "swig minor: ${SWIG_VERSION_MINOR}")
message(STATUS "swig patch: ${SWIG_VERSION_PATCH}")
include(UseSWIG)

if(SWIG_VERSION_MAJOR GREATER 3)
	list(APPEND CMAKE_SWIG_FLAGS "-doxygen")
endif()

# Find dotnet
find_program(DOTNET_EXECUTABLE dotnet)
if(NOT DOTNET_EXECUTABLE)
  message(FATAL_ERROR "Check for dotnet Program: not found")
else()
  message(STATUS "Found dotnet Program: ${DOTNET_EXECUTABLE}")
endif()

