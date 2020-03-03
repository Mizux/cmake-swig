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

if(${SWIG_VERSION} VERSION_GREATER_EQUAL 4)
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

# Find maven
find_program(MAVEN_EXECUTABLE mvn)
if(NOT MAVEN_EXECUTABLE)
  message(FATAL_ERROR "Check for maven Program: not found")
else()
  message(STATUS "Found maven Program: ${MAVEN_EXECUTABLE}")
endif()

# Swig wrap all libraries
foreach(SUBPROJECT IN ITEMS Foo Bar FooBar)
  add_subdirectory(${SUBPROJECT}/java)
  list(APPEND java_libs java_${SUBPROJECT})
endforeach()

######################
##  Java Packaging  ##
######################
configure_file(java/pom.xml.in java/pom.xml @ONLY)

add_custom_target(dotnet_native
  DEPENDS
    ${java_libs}
    ${PROJECT_BINARY_DIR}/java/pom.xml
    COMMAND ${MAVEN_EXECUTABLE} package
  WORKING_DIRECTORY java
  )

