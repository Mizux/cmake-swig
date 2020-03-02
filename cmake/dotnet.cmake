if(NOT BUILD_DOTNET)
  return()
endif()

# Use latest UseSWIG module
cmake_minimum_required(VERSION 3.14)

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR ".Net: missing FooBar TARGET")
endif()

# Will need swig
find_package(SWIG REQUIRED)
include(UseSWIG)

if(UNIX AND NOT APPLE)
	list(APPEND CMAKE_SWIG_FLAGS "-DSWIGWORDSIZE64")
endif()

# Find dotnet
find_program(DOTNET_EXECUTABLE dotnet)
if(NOT DOTNET_EXECUTABLE)
  message(FATAL_ERROR "Check for dotnet Program: not found")
else()
  message(STATUS "Found dotnet Program: ${DOTNET_EXECUTABLE}")
endif()

# Swig wrap all libraries
foreach(SUBPROJECT IN ITEMS Foo Bar FooBar)
  add_subdirectory(${SUBPROJECT}/dotnet)
  list(APPEND dotnet_libs dotnet_${SUBPROJECT})
endforeach()

######################
##  .Net Packaging  ##
######################
if(APPLE)
  set(RUNTIME_IDENTIFIER osx-x64)
elseif(UNIX)
  set(RUNTIME_IDENTIFIER linux-x64)
elseif(WIN32)
  set(RUNTIME_IDENTIFIER win-x64)
else()
  message(FATAL_ERROR "Unsupported system !")
endif()
set(CMAKE_SWIG_DOTNET_NATIVE Mizux.CMakeSwig.runtime.${RUNTIME_IDENTIFIER})

add_custom_target(dotnet_native
  DEPENDS
    ${dotnet_libs}
    ${PROJECT_BINARY_DIR}/dotnet/${CMAKE_SWIG_DOTNET_NATIVE}/${CMAKE_SWIG_DOTNET_NATIVE}.csproj
  COMMAND ${CMAKE_COMMAND} -E make_directory packages
  COMMAND ${DOTNET_CLI} build -c Release /p:Platform=x64 ${CMAKE_SWIG_DOTNET_NATIVE}/${CMAKE_SWIG_DOTNET_NATIVE}.csproj
  COMMAND ${DOTNET_CLI} pack -c Release ${CMAKE_SWIG_DOTNET_NATIVE}/${CMAKE_SWIG_DOTNET_NATIVE}.csproj
  WORKING_DIRECTORY dotnet
  )

configure_file(
  dotnet/runtime.csproj.in
  dotnet/${CMAKE_SWIG_DOTNET_NATIVE}/${CMAKE_SWIG_DOTNET_NATIVE}.csproj
  @ONLY)

