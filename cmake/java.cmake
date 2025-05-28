if(NOT BUILD_JAVA)
  return()
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

# Find Java and JNI
find_package(Java COMPONENTS Development REQUIRED)
find_package(JNI REQUIRED)

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

# Needed by java/CMakeLists.txt
set(JAVA_DOMAIN_NAME "mizux")
set(JAVA_DOMAIN_EXTENSION "org")

set(JAVA_GROUP "${JAVA_DOMAIN_EXTENSION}.${JAVA_DOMAIN_NAME}")
set(JAVA_ARTIFACT "cmakeswig")

set(JAVA_PACKAGE "${JAVA_GROUP}.${JAVA_ARTIFACT}")
if(APPLE)
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)")
    set(NATIVE_IDENTIFIER darwin-aarch64)
  else()
    set(NATIVE_IDENTIFIER darwin-x86-64)
  endif()
elseif(UNIX)
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)")
    set(NATIVE_IDENTIFIER linux-aarch64)
  else()
    set(NATIVE_IDENTIFIER linux-x86-64)
  endif()
elseif(WIN32)
  set(NATIVE_IDENTIFIER win32-x86-64)
else()
  message(FATAL_ERROR "Unsupported system !")
endif()
set(JAVA_NATIVE_PROJECT ${JAVA_ARTIFACT}-${NATIVE_IDENTIFIER})
message(STATUS "Java runtime project: ${JAVA_NATIVE_PROJECT}")
set(JAVA_NATIVE_PROJECT_DIR ${PROJECT_BINARY_DIR}/java/${JAVA_NATIVE_PROJECT})
message(STATUS "Java runtime project build path: ${JAVA_NATIVE_PROJECT_DIR}")

set(JAVA_PROJECT ${JAVA_ARTIFACT}-java)
message(STATUS "Java project: ${JAVA_PROJECT}")
set(JAVA_PROJECT_DIR ${PROJECT_BINARY_DIR}/java/${JAVA_PROJECT})
message(STATUS "Java project build path: ${JAVA_PROJECT_DIR}")

# Create the native library
add_library(jni${JAVA_ARTIFACT} SHARED "")
set_target_properties(jni${JAVA_ARTIFACT} PROPERTIES
  POSITION_INDEPENDENT_CODE ON)
# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(jni${JAVA_ARTIFACT} PROPERTIES INSTALL_RPATH "@loader_path")
  # Xcode fails to build if library doesn't contains at least one source file.
  if(XCODE)
    file(GENERATE
      OUTPUT ${PROJECT_BINARY_DIR}/jni${JAVA_ARTIFACT}/version.cpp
      CONTENT "namespace {char* version = \"${PROJECT_VERSION}\";}")
    target_sources(jni${JAVA_ARTIFACT} PRIVATE ${PROJECT_BINARY_DIR}/jni${JAVA_ARTIFACT}/version.cpp)
  endif()
elseif(UNIX)
  set_target_properties(jni${JAVA_ARTIFACT} PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()

set(JAVA_SRC_PATH src/main/java/${JAVA_DOMAIN_EXTENSION}/${JAVA_DOMAIN_NAME}/${JAVA_ARTIFACT})
set(JAVA_TEST_PATH src/test/java/${JAVA_DOMAIN_EXTENSION}/${JAVA_DOMAIN_NAME}/${JAVA_ARTIFACT})
set(JAVA_RESSOURCES_PATH src/main/resources)

#################
##  Java Test  ##
#################
# add_java_test()
# CMake function to generate and build java test.
# Parameters:
#  FILE_NAME: the Java filename
#  COMPONENT_NAME: name of the ortools/ subdir where the test is located
#  note: automatically determined if located in ortools/<component>/java/
# e.g.:
# add_java_test(
#   FILE_NAME
#     ${PROJECT_SOURCE_DIR}/ortools/foo/java/BarTest.java
#   COMPONENT_NAME
#     foo
# )
function(add_java_test)
  set(options "")
  set(oneValueArgs FILE_NAME COMPONENT_NAME)
  set(multiValueArgs "")
  cmake_parse_arguments(TEST
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  if(NOT TEST_FILE_NAME)
    message(FATAL_ERROR "no FILE_NAME provided")
  endif()
  get_filename_component(TEST_NAME ${TEST_FILE_NAME} NAME_WE)

  message(STATUS "Configuring test ${TEST_FILE_NAME} ...")

  if(NOT TEST_COMPONENT_NAME)
    # test is located in ortools/<component_name>/java/
    get_filename_component(WRAPPER_DIR ${TEST_FILE_NAME} DIRECTORY)
    get_filename_component(COMPONENT_DIR ${WRAPPER_DIR} DIRECTORY)
    get_filename_component(COMPONENT_NAME ${COMPONENT_DIR} NAME)
  else()
    set(COMPONENT_NAME ${TEST_COMPONENT_NAME})
  endif()

  set(JAVA_TEST_DIR ${PROJECT_BINARY_DIR}/java/${COMPONENT_NAME}/${TEST_NAME})
  message(STATUS "build path: ${JAVA_TEST_DIR}")

  add_custom_command(
    OUTPUT ${JAVA_TEST_DIR}/${JAVA_TEST_PATH}/${TEST_NAME}.java
    COMMAND ${CMAKE_COMMAND} -E make_directory
      ${JAVA_TEST_DIR}/${JAVA_TEST_PATH}
    COMMAND ${CMAKE_COMMAND} -E copy
      ${TEST_FILE_NAME}
      ${JAVA_TEST_DIR}/${JAVA_TEST_PATH}/
    MAIN_DEPENDENCY ${TEST_FILE_NAME}
    VERBATIM
  )

  string(TOLOWER ${TEST_NAME} JAVA_TEST_PROJECT)
  configure_file(
    ${PROJECT_SOURCE_DIR}/java/pom-test.xml.in
    ${JAVA_TEST_DIR}/pom.xml
    @ONLY)

  add_custom_command(
    OUTPUT ${JAVA_TEST_DIR}/timestamp
    COMMAND ${MAVEN_EXECUTABLE} compile -B
    COMMAND ${CMAKE_COMMAND} -E touch ${JAVA_TEST_DIR}/timestamp
    DEPENDS
      ${JAVA_TEST_DIR}/pom.xml
      ${JAVA_TEST_DIR}/${JAVA_TEST_PATH}/${TEST_NAME}.java
      java_package
    BYPRODUCTS
      ${JAVA_TEST_DIR}/target
    COMMENT "Compiling Java ${COMPONENT_NAME}/${TEST_NAME}.java (${JAVA_TEST_DIR}/timestamp)"
    WORKING_DIRECTORY ${JAVA_TEST_DIR})

  add_custom_target(java_${COMPONENT_NAME}_${TEST_NAME} ALL
    DEPENDS
      ${JAVA_TEST_DIR}/timestamp
    WORKING_DIRECTORY ${JAVA_TEST_DIR})

  if(BUILD_TESTING)
    add_test(
      NAME java_${COMPONENT_NAME}_${TEST_NAME}
      COMMAND ${MAVEN_EXECUTABLE} test
      WORKING_DIRECTORY ${JAVA_TEST_DIR})
  endif()
  message(STATUS "Configuring test ${TEST_FILE_NAME} ...DONE")
endfunction()

#####################
##  JAVA WRAPPERS  ##
#####################
list(APPEND CMAKE_SWIG_FLAGS "-I${PROJECT_SOURCE_DIR}")

# Swig wrap all libraries
foreach(SUBPROJECT IN ITEMS Foo Bar FooBar)
  add_subdirectory(${SUBPROJECT}/java)
  target_link_libraries(jni${JAVA_ARTIFACT} PRIVATE jni${SUBPROJECT})
endforeach()

#################################
##  Java Native Maven Package  ##
#################################
file(MAKE_DIRECTORY ${JAVA_NATIVE_PROJECT_DIR}/${JAVA_RESSOURCES_PATH}/${JAVA_NATIVE_PROJECT})

configure_file(
  ${PROJECT_SOURCE_DIR}/java/pom-native.xml.in
  ${JAVA_NATIVE_PROJECT_DIR}/pom.xml
  @ONLY)

set(is_windows "$<PLATFORM_ID:Windows>")
set(is_not_windows "$<NOT:$<PLATFORM_ID:Windows>>")

set(is_foo_shared "$<STREQUAL:$<TARGET_PROPERTY:Foo,TYPE>,SHARED_LIBRARY>")
set(need_unix_foo_lib "$<AND:${is_not_windows},${is_foo_shared}>")
set(need_windows_foo_lib "$<AND:${is_windows},${is_foo_shared}>")

set(is_bar_shared "$<STREQUAL:$<TARGET_PROPERTY:Bar,TYPE>,SHARED_LIBRARY>")
set(need_unix_bar_lib "$<AND:${is_not_windows},${is_bar_shared}>")
set(need_windows_bar_lib "$<AND:${is_windows},${is_bar_shared}>")

set(is_foobar_shared "$<STREQUAL:$<TARGET_PROPERTY:FooBar,TYPE>,SHARED_LIBRARY>")
set(need_unix_foobar_lib "$<AND:${is_not_windows},${is_foobar_shared}>")
set(need_windows_foobar_lib "$<AND:${is_windows},${is_foobar_shared}>")

add_custom_command(
  OUTPUT ${JAVA_NATIVE_PROJECT_DIR}/timestamp
  COMMAND ${CMAKE_COMMAND} -E remove -f timestamp
  COMMAND ${CMAKE_COMMAND} -E make_directory ${JAVA_RESSOURCES_PATH}/${JAVA_NATIVE_PROJECT}
  COMMAND ${CMAKE_COMMAND} -E
    $<IF:${is_foo_shared},copy,true>
    $<${need_unix_foo_lib}:$<TARGET_SONAME_FILE:${PROJECT_NAMESPACE}::Foo>>
    $<${need_windows_foo_lib}:$<TARGET_FILE:${PROJECT_NAMESPACE}::Foo>>
    ${JAVA_RESSOURCES_PATH}/${JAVA_NATIVE_PROJECT}/

  COMMAND ${CMAKE_COMMAND} -E
    $<IF:${is_bar_shared},copy,true>
    $<${need_unix_bar_lib}:$<TARGET_SONAME_FILE:${PROJECT_NAMESPACE}::Bar>>
    $<${need_windows_bar_lib}:$<TARGET_FILE:${PROJECT_NAMESPACE}::Bar>>
    ${JAVA_RESSOURCES_PATH}/${JAVA_NATIVE_PROJECT}/

  COMMAND ${CMAKE_COMMAND} -E
    $<IF:${is_foobar_shared},copy,true>
    $<${need_unix_foobar_lib}:$<TARGET_SONAME_FILE:${PROJECT_NAMESPACE}::FooBar>>
    $<${need_windows_foobar_lib}:$<TARGET_FILE:${PROJECT_NAMESPACE}::FooBar>>
    ${JAVA_RESSOURCES_PATH}/${JAVA_NATIVE_PROJECT}/

  COMMAND ${CMAKE_COMMAND} -E copy
    $<TARGET_FILE:jni${JAVA_ARTIFACT}>
    ${JAVA_RESSOURCES_PATH}/${JAVA_NATIVE_PROJECT}/

  COMMAND ${MAVEN_EXECUTABLE} compile -B
  COMMAND ${MAVEN_EXECUTABLE} package -B $<$<BOOL:${BUILD_FAT_JAR}>:-Dfatjar=true>
  COMMAND ${MAVEN_EXECUTABLE} install -B $<$<BOOL:${SKIP_GPG}>:-Dgpg.skip=true>
  COMMAND ${CMAKE_COMMAND} -E touch ${JAVA_NATIVE_PROJECT_DIR}/timestamp
  DEPENDS
    ${JAVA_NATIVE_PROJECT_DIR}/pom.xml
    jni${JAVA_ARTIFACT}
  BYPRODUCTS
    ${JAVA_NATIVE_PROJECT_DIR}/target
  COMMENT "Generate Java native package ${JAVA_NATIVE_PROJECT} (${JAVA_NATIVE_PROJECT_DIR}/timestamp)"
  WORKING_DIRECTORY ${JAVA_NATIVE_PROJECT_DIR})

add_custom_target(java_native_package
  DEPENDS
    ${JAVA_NATIVE_PROJECT_DIR}/timestamp
  WORKING_DIRECTORY ${JAVA_NATIVE_PROJECT_DIR})

add_custom_target(java_native_deploy
  COMMAND ${MAVEN_EXECUTABLE} deploy
  WORKING_DIRECTORY ${JAVA_NATIVE_PROJECT_DIR})
add_dependencies(java_native_deploy java_native_package)

##########################
##  Java Maven Package  ##
##########################
file(MAKE_DIRECTORY ${JAVA_PROJECT_DIR}/${JAVA_SRC_PATH})

if(UNIVERSAL_JAVA_PACKAGE)
  configure_file(
    ${PROJECT_SOURCE_DIR}/java/pom-full.xml.in
    ${JAVA_PROJECT_DIR}/pom.xml
    @ONLY)
else()
  configure_file(
    ${PROJECT_SOURCE_DIR}/java/pom-local.xml.in
    ${JAVA_PROJECT_DIR}/pom.xml
    @ONLY)
endif()

file(GLOB_RECURSE java_files RELATIVE ${PROJECT_SOURCE_DIR}/java
  "java/*.java")
#message(WARNING "list: ${java_files}")
set(JAVA_SRCS)
foreach(JAVA_FILE IN LISTS java_files)
  #message(STATUS "java: ${JAVA_FILE}")
  set(JAVA_OUT ${JAVA_PROJECT_DIR}/${JAVA_SRC_PATH}/${JAVA_FILE})
  #message(STATUS "java out: ${JAVA_OUT}")
  add_custom_command(
    OUTPUT ${JAVA_OUT}
    COMMAND ${CMAKE_COMMAND} -E copy
      ${PROJECT_SOURCE_DIR}/java/${JAVA_FILE}
      ${JAVA_OUT}
    DEPENDS ${PROJECT_SOURCE_DIR}/java/${JAVA_FILE}
    COMMENT "Copy Java file ${JAVA_FILE}"
    VERBATIM)
  list(APPEND JAVA_SRCS ${JAVA_OUT})
endforeach()

add_custom_command(
  OUTPUT ${JAVA_PROJECT_DIR}/timestamp
  COMMAND ${MAVEN_EXECUTABLE} compile -B
  COMMAND ${MAVEN_EXECUTABLE} package -B $<$<BOOL:${BUILD_FAT_JAR}>:-Dfatjar=true>
  COMMAND ${MAVEN_EXECUTABLE} install -B $<$<BOOL:${SKIP_GPG}>:-Dgpg.skip=true>
  COMMAND ${CMAKE_COMMAND} -E touch ${JAVA_PROJECT_DIR}/timestamp
  DEPENDS
    ${JAVA_PROJECT_DIR}/pom.xml
    ${JAVA_SRCS}
    ${JAVA_NATIVE_PROJECT_DIR}/timestamp
    java_native_package
  BYPRODUCTS
    ${JAVA_PROJECT_DIR}/target
  COMMENT "Generate Java package ${JAVA_PROJECT} (${JAVA_PROJECT_DIR}/timestamp)"
  WORKING_DIRECTORY ${JAVA_PROJECT_DIR})

add_custom_target(java_package ALL
  DEPENDS
    ${JAVA_PROJECT_DIR}/timestamp
  WORKING_DIRECTORY ${JAVA_PROJECT_DIR})

add_custom_target(java_deploy
  COMMAND ${MAVEN_EXECUTABLE} deploy
  WORKING_DIRECTORY ${JAVA_PROJECT_DIR})
add_dependencies(java_deploy java_package)

####################
##  Java Example  ##
####################
# add_java_example()
# CMake function to generate and build java example.
# Parameters:
#  FILE_NAME: the Java filename
#  COMPONENT_NAME: name of the example/ subdir where the test is located
#  note: automatically determined if located in examples/<component>/
# e.g.:
# add_java_example(
#   FILE_NAME
#     ${PROJECT_SOURCE_DIR}/examples/foo/Bar.java
#   COMPONENT_NAME
#     foo
# )
function(add_java_example)
  set(options "")
  set(oneValueArgs FILE_NAME COMPONENT_NAME)
  set(multiValueArgs "")
  cmake_parse_arguments(EXAMPLE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
if(NOT EXAMPLE_FILE_NAME)
    message(FATAL_ERROR "no FILE_NAME provided")
  endif()
  get_filename_component(EXAMPLE_NAME ${EXAMPLE_FILE_NAME} NAME_WE)

  message(STATUS "Configuring example ${EXAMPLE_FILE_NAME} ...")

  if(NOT EXAMPLE_COMPONENT_NAME)
    # sample is located in examples/<component_name>/
    get_filename_component(COMPONENT_DIR ${EXAMPLE_FILE_NAME} DIRECTORY)
    get_filename_component(COMPONENT_NAME ${COMPONENT_DIR} NAME)
  else()
    set(COMPONENT_NAME ${EXAMPLE_COMPONENT_NAME})
  endif()

  set(JAVA_EXAMPLE_DIR ${PROJECT_BINARY_DIR}/java/${COMPONENT_NAME}/${EXAMPLE_NAME})
  message(STATUS "build path: ${JAVA_EXAMPLE_DIR}")

  add_custom_command(
    OUTPUT ${JAVA_EXAMPLE_DIR}/${JAVA_SRC_PATH}/${COMPONENT_NAME}/${EXAMPLE_NAME}.java
    COMMAND ${CMAKE_COMMAND} -E make_directory
      ${JAVA_EXAMPLE_DIR}/${JAVA_SRC_PATH}/${COMPONENT_NAME}
    COMMAND ${CMAKE_COMMAND} -E copy
      ${EXAMPLE_FILE_NAME}
      ${JAVA_EXAMPLE_DIR}/${JAVA_SRC_PATH}/${COMPONENT_NAME}/
    MAIN_DEPENDENCY ${EXAMPLE_FILE_NAME}
    VERBATIM
  )

  string(TOLOWER ${EXAMPLE_NAME} JAVA_EXAMPLE_PROJECT)
  set(JAVA_MAIN_CLASS
    "${JAVA_PACKAGE}.${COMPONENT_NAME}.${EXAMPLE_NAME}")
  configure_file(
    ${PROJECT_SOURCE_DIR}/java/pom-example.xml.in
    ${JAVA_EXAMPLE_DIR}/pom.xml
    @ONLY)

  add_custom_command(
    OUTPUT ${JAVA_EXAMPLE_DIR}/timestamp
    COMMAND ${MAVEN_EXECUTABLE} compile -B
    COMMAND ${CMAKE_COMMAND} -E touch ${JAVA_EXAMPLE_DIR}/timestamp
    DEPENDS
      ${JAVA_EXAMPLE_DIR}/pom.xml
      ${JAVA_EXAMPLE_DIR}/${JAVA_SRC_PATH}/${COMPONENT_NAME}/${EXAMPLE_NAME}.java
      java_package
    BYPRODUCTS
      ${JAVA_EXAMPLE_DIR}/target
    COMMENT "Compiling Java ${COMPONENT_NAME}/${EXAMPLE_NAME}.java (${JAVA_EXAMPLE_DIR}/timestamp)"
    WORKING_DIRECTORY ${JAVA_EXAMPLE_DIR})

  add_custom_target(java_${COMPONENT_NAME}_${EXAMPLE_NAME} ALL
    DEPENDS
      ${JAVA_EXAMPLE_DIR}/timestamp
    WORKING_DIRECTORY ${JAVA_EXAMPLE_DIR})

  if(BUILD_TESTING)
    add_test(
      NAME java_${COMPONENT_NAME}_${EXAMPLE_NAME}
      COMMAND ${MAVEN_EXECUTABLE} exec:java
      WORKING_DIRECTORY ${JAVA_EXAMPLE_DIR})
  endif()
  message(STATUS "Configuring example ${EXAMPLE_FILE_NAME} ...DONE")
endfunction()
