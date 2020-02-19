if(NOT BUILD_JAVA)
  return()
endif()

# Use latest UseSWIG module
cmake_minimum_required(VERSION 3.14)

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR "Java: missing FooBar TARGET")
endif()

# Will need swig
find_package(SWIG REQUIRED)
include(UseSWIG)

if(${SWIG_VERSION} VERSION_GREATER 3)
	list(APPEND CMAKE_SWIG_FLAGS "-doxygen")
endif()

if(UNIX AND NOT APPLE)
	list(APPEND CMAKE_SWIG_FLAGS "-DSWIGWORDSIZE64")
endif()

# Find java
find_package(Java COMPONENTS Development REQUIRED)
message(STATUS "Found Java: ${Java_JAVA_EXECUTABLE} (found version \"${Java_VERSION_STRING}\")")

find_package(JNI REQUIRED)
message(STATUS "Found JNI: ${JNI_FOUND}")

