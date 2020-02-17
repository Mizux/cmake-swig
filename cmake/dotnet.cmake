if(NOT BUILD_DOTNET)
  return()
endif()

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR ".Net: missing FooBar TARGET")
endif()

# Will need swig
find_package(SWIG REQUIRED)
include(UseSWIG)

# Find dotnet
find_program(DOTNET_EXECUTABLE dotnet)
if(NOT DOTNET_EXECUTABLE)
  message(FATAL_ERROR "Check for dotnet Program: not found")
else()
  message(STATUS "Found dotnet Program: ${DOTNET_EXECUTABLE}")
endif()

