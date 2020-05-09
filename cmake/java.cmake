if(NOT BUILD_JAVA)
  return()
endif()

# Use latest UseSWIG module
cmake_minimum_required(VERSION 3.14)

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR "Java: missing FooBar TARGET")
endif()

# Will need swig
set(CMAKE_SWIG_FLAGS)
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
# On windows mvn spawn a process while mvn.cmd is a blocking command
if(UNIX)
	find_program(MAVEN_EXECUTABLE mvn)
else()
	find_program(MAVEN_EXECUTABLE mvn.cmd)
endif()

if(NOT MAVEN_EXECUTABLE)
  message(FATAL_ERROR "Check for maven Program: not found")
else()
  message(STATUS "Found Maven: ${MAVEN_EXECUTABLE}")
endif()

# Create the native library
add_library(jnicmakeswig SHARED "")
set_target_properties(jnicmakeswig PROPERTIES
  POSITION_INDEPENDENT_CODE ON)
# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(jnicmakeswig PROPERTIES
    INSTALL_RPATH "@loader_path")
elseif(UNIX)
  set_target_properties(jnicmakeswig PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()

# Swig wrap all libraries
set(CMAKE_SWIG_JAVA org.mizux.cmakeswig)
foreach(SUBPROJECT IN ITEMS Foo Bar FooBar)
  add_subdirectory(${SUBPROJECT}/java)
  target_link_libraries(jnicmakeswig PRIVATE jni${SUBPROJECT})
endforeach()

##########################
##  Java Maven Package  ##
##########################
if(APPLE)
  set(NATIVE_IDENTIFIER darwin)
elseif(UNIX)
  set(NATIVE_IDENTIFIER linux-x86-64)
elseif(WIN32)
  set(NATIVE_IDENTIFIER win32-x86-64)
else()
  message(FATAL_ERROR "Unsupported system !")
endif()
set(CMAKE_SWIG_JAVA_NATIVE ${CMAKE_SWIG_JAVA}.${NATIVE_IDENTIFIER})

# pom*.xml.in contains:
# CMake variable(s) (@PROJECT_NAME@) that configure_file() can manage and
# generator expression ($<TARGET_FILE:...>) that file(GENERATE) can manage.
configure_file(
  ${PROJECT_SOURCE_DIR}/java/pom-native.xml.in
  ${PROJECT_BINARY_DIR}/java/pom-native.xml.in
  @ONLY)
file(GENERATE
  OUTPUT ${PROJECT_BINARY_DIR}/java/$<CONFIG>/pom-native.xml
  INPUT ${PROJECT_BINARY_DIR}/java/pom-native.xml.in)

add_custom_command(
  OUTPUT java/${CMAKE_SWIG_JAVA_NATIVE}/pom.xml
  COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SWIG_JAVA_NATIVE}
  COMMAND ${CMAKE_COMMAND} -E copy ./$<CONFIG>/pom-native.xml ${CMAKE_SWIG_JAVA_NATIVE}/pom.xml
  BYPRODUCTS
  java/${CMAKE_SWIG_JAVA_NATIVE}
  WORKING_DIRECTORY java)

add_custom_target(java_native_package
  DEPENDS
  jnicmakeswig
  java/${CMAKE_SWIG_JAVA_NATIVE}/pom.xml
  COMMAND ${CMAKE_COMMAND} -E remove_directory src
  COMMAND ${CMAKE_COMMAND} -E make_directory src/main/resources/${NATIVE_IDENTIFIER}
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:Foo> src/main/resources/${NATIVE_IDENTIFIER}/
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:Bar> src/main/resources/${NATIVE_IDENTIFIER}/
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:FooBar> src/main/resources/${NATIVE_IDENTIFIER}/
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:jnicmakeswig> src/main/resources/${NATIVE_IDENTIFIER}/
  COMMAND ${MAVEN_EXECUTABLE} compile
  COMMAND ${MAVEN_EXECUTABLE} package
  COMMAND ${MAVEN_EXECUTABLE} install
  WORKING_DIRECTORY java/${CMAKE_SWIG_JAVA_NATIVE})

# Pure Java Package
configure_file(
  ${PROJECT_SOURCE_DIR}/java/pom-local.xml.in
  ${PROJECT_BINARY_DIR}/java/pom-local.xml.in
  @ONLY)
file(GENERATE
  OUTPUT ${PROJECT_BINARY_DIR}/java/$<CONFIG>/pom-local.xml
  INPUT ${PROJECT_BINARY_DIR}/java/pom-local.xml.in)

add_custom_command(
  OUTPUT java/${CMAKE_SWIG_JAVA}/pom.xml
  COMMAND ${CMAKE_COMMAND} -E copy ./$<CONFIG>/pom-local.xml ${CMAKE_SWIG_JAVA}/pom.xml
  BYPRODUCTS
  java/${CMAKE_SWIG_JAVA}
  WORKING_DIRECTORY java)

add_custom_target(java_package ALL
  DEPENDS
  java_native_package
  java/${CMAKE_SWIG_JAVA}/pom.xml
  COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/java/Loader.java src/main/java/org/mizux/cmakeswig
  COMMAND ${MAVEN_EXECUTABLE} compile
  COMMAND ${MAVEN_EXECUTABLE} package
  COMMAND ${MAVEN_EXECUTABLE} install
  WORKING_DIRECTORY java/${CMAKE_SWIG_JAVA}
  )

############
##  Test  ##
############
set(CMAKE_SWIG_JAVA_TEST ${CMAKE_SWIG_JAVA}.test)
if(BUILD_TESTING)
  configure_file(
    ${PROJECT_SOURCE_DIR}/java/pom-test.xml.in
    ${PROJECT_BINARY_DIR}/java/pom-test.xml.in
    @ONLY)
  file(GENERATE
    OUTPUT ${PROJECT_BINARY_DIR}/java/$<CONFIG>/pom-test.xml
    INPUT ${PROJECT_BINARY_DIR}/java/pom-test.xml.in)

  add_custom_command(
    OUTPUT java/${CMAKE_SWIG_JAVA_TEST}/pom.xml
    COMMAND ${CMAKE_COMMAND} -E copy ./$<CONFIG>/pom-test.xml ${CMAKE_SWIG_JAVA_TEST}/pom.xml
    BYPRODUCTS
    java/${CMAKE_SWIG_JAVA_TEST}
    WORKING_DIRECTORY java)

  add_custom_target(java_test_package ALL
    DEPENDS
    java_package
    java/${CMAKE_SWIG_JAVA_TEST}/pom.xml
    COMMAND ${CMAKE_COMMAND} -E remove_directory src
    COMMAND ${CMAKE_COMMAND} -E make_directory src/main/java/org/mizux/cmakeswig
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/java/Test.java src/main/java/org/mizux/cmakeswig
    COMMAND ${MAVEN_EXECUTABLE} compile
    COMMAND ${MAVEN_EXECUTABLE} package
    WORKING_DIRECTORY java/${CMAKE_SWIG_JAVA_TEST})

  add_test(
    NAME JavaTest
    COMMAND ${MAVEN_EXECUTABLE} exec:java -Dexec.mainClass=org.mizux.cmakeswig.Test
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/java/${CMAKE_SWIG_JAVA_TEST})
endif()
