if(NOT BUILD_DOTNET)
  return()
endif()

# Will need swig
set(CMAKE_SWIG_FLAGS)
find_package(SWIG REQUIRED)
include(UseSWIG)

#if(${SWIG_VERSION} VERSION_GREATER_EQUAL 4)
#  list(APPEND CMAKE_SWIG_FLAGS "-doxygen")
#endif()

if(UNIX AND NOT APPLE)
  list(APPEND CMAKE_SWIG_FLAGS "-DSWIGWORDSIZE64")
endif()

# Find dotnet cli
find_program(DOTNET_EXECUTABLE NAMES dotnet)
if(NOT DOTNET_EXECUTABLE)
  message(FATAL_ERROR "Check for dotnet Program: not found")
else()
  message(STATUS "Found dotnet Program: ${DOTNET_EXECUTABLE}")
endif()

# Needed by dotnet/CMakeLists.txt
set(DOTNET_PACKAGE Mizux.CMakeSwig)
set(DOTNET_PACKAGES_DIR "${PROJECT_BINARY_DIR}/dotnet/packages")

# see: https://docs.microsoft.com/en-us/dotnet/core/rid-catalog
if(APPLE)
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)")
    set(RUNTIME_IDENTIFIER osx-arm64)
  else()
    set(RUNTIME_IDENTIFIER osx-x64)
  endif()
elseif(UNIX)
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)")
    set(RUNTIME_IDENTIFIER linux-arm64)
  else()
    set(RUNTIME_IDENTIFIER linux-x64)
  endif()
elseif(WIN32)
  set(RUNTIME_IDENTIFIER win-x64)
else()
  message(FATAL_ERROR "Unsupported system !")
endif()
set(DOTNET_NATIVE_PROJECT ${DOTNET_PACKAGE}.runtime.${RUNTIME_IDENTIFIER})
message(STATUS ".Net runtime project: ${DOTNET_NATIVE_PROJECT}")
set(DOTNET_NATIVE_PROJECT_DIR ${PROJECT_BINARY_DIR}/dotnet/${DOTNET_NATIVE_PROJECT})
message(STATUS ".Net runtime project build path: ${DOTNET_NATIVE_PROJECT_DIR}")

# see: Platform
if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)")
  set(DOTNET_PLATFORM arm64)
else()
  set(DOTNET_PLATFORM x64)
endif()

# see: https://docs.microsoft.com/en-us/dotnet/standard/frameworks
if(USE_DOTNET_CORE_31 AND USE_DOTNET_6)
  set(DOTNET_TFM "<TargetFrameworks>netcoreapp3.1;net6.0</TargetFrameworks>")
elseif(USE_DOTNET_6)
  set(DOTNET_TFM "<TargetFramework>net6.0</TargetFramework>")
elseif(USE_DOTNET_CORE_31)
  set(DOTNET_TFM "<TargetFramework>netcoreapp3.1</TargetFramework>")
else()
  message(FATAL_ERROR "No .Net SDK selected !")
endif()

set(DOTNET_PROJECT ${DOTNET_PACKAGE})
message(STATUS ".Net project: ${DOTNET_PROJECT}")
set(DOTNET_PROJECT_DIR ${PROJECT_BINARY_DIR}/dotnet/${DOTNET_PROJECT})
message(STATUS ".Net project build path: ${DOTNET_PROJECT_DIR}")

# Create the native library
add_library(mizux-cmakeswig-native SHARED "")
set_target_properties(mizux-cmakeswig-native PROPERTIES
  PREFIX ""
  POSITION_INDEPENDENT_CODE ON)
# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(mizux-cmakeswig-native PROPERTIES INSTALL_RPATH "@loader_path")
  # Xcode fails to build if library doesn't contains at least one source file.
  if(XCODE)
    file(GENERATE
      OUTPUT ${PROJECT_BINARY_DIR}/mizux-cmakeswig-native/version.cpp
      CONTENT "namespace {char* version = \"${PROJECT_VERSION}\";}")
    target_sources(mizux-cmakeswig-native PRIVATE ${PROJECT_BINARY_DIR}/mizux-cmakeswig-native/version.cpp)
  endif()
elseif(UNIX)
  set_target_properties(mizux-cmakeswig-native PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()

list(APPEND CMAKE_SWIG_FLAGS ${FLAGS} "-I${PROJECT_SOURCE_DIR}")

# Swig wrap all libraries
foreach(SUBPROJECT IN ITEMS Foo Bar FooBar)
  add_subdirectory(${SUBPROJECT}/dotnet)
  target_link_libraries(mizux-cmakeswig-native PRIVATE dotnet_${SUBPROJECT})
endforeach()

file(COPY ${PROJECT_SOURCE_DIR}/dotnet/logo.png DESTINATION ${PROJECT_BINARY_DIR}/dotnet)
set(DOTNET_LOGO_DIR "${PROJECT_BINARY_DIR}/dotnet")
configure_file(${PROJECT_SOURCE_DIR}/dotnet/Directory.Build.props.in ${PROJECT_BINARY_DIR}/dotnet/Directory.Build.props)

file(MAKE_DIRECTORY ${DOTNET_PACKAGES_DIR})
############################
##  .Net Runtime Package  ##
############################
# *.csproj.in contains:
# CMake variable(s) (@PROJECT_NAME@) that configure_file() can manage and
# generator expression ($<TARGET_FILE:...>) that file(GENERATE) can manage.
configure_file(
  ${PROJECT_SOURCE_DIR}/dotnet/${DOTNET_PACKAGE}.runtime.csproj.in
  ${DOTNET_NATIVE_PROJECT_DIR}/${DOTNET_NATIVE_PROJECT}.csproj.in
  @ONLY)
file(GENERATE
  OUTPUT ${DOTNET_NATIVE_PROJECT_DIR}/$<CONFIG>/${DOTNET_NATIVE_PROJECT}.csproj.in
  INPUT ${DOTNET_NATIVE_PROJECT_DIR}/${DOTNET_NATIVE_PROJECT}.csproj.in)

add_custom_command(
  OUTPUT ${DOTNET_NATIVE_PROJECT_DIR}/${DOTNET_NATIVE_PROJECT}.csproj
  COMMAND ${CMAKE_COMMAND} -E copy ./$<CONFIG>/${DOTNET_NATIVE_PROJECT}.csproj.in ${DOTNET_NATIVE_PROJECT}.csproj
  DEPENDS
    ${DOTNET_NATIVE_PROJECT_DIR}/$<CONFIG>/${DOTNET_NATIVE_PROJECT}.csproj.in
  WORKING_DIRECTORY ${DOTNET_NATIVE_PROJECT_DIR})

add_custom_command(
  OUTPUT ${DOTNET_NATIVE_PROJECT_DIR}/timestamp
  COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} build -c Release /p:Platform=${DOTNET_PLATFORM} ${DOTNET_NATIVE_PROJECT}.csproj
  COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} pack -c Release ${DOTNET_NATIVE_PROJECT}.csproj
  COMMAND ${CMAKE_COMMAND} -E touch ${DOTNET_NATIVE_PROJECT_DIR}/timestamp
  DEPENDS
    ${PROJECT_BINARY_DIR}/dotnet/Directory.Build.props
   ${DOTNET_NATIVE_PROJECT_DIR}/${DOTNET_NATIVE_PROJECT}.csproj
   mizux-cmakeswig-native
  BYPRODUCTS
    ${DOTNET_NATIVE_PROJECT_DIR}/bin
    ${DOTNET_NATIVE_PROJECT_DIR}/obj
  VERBATIM
  COMMENT "Generate .Net native package ${DOTNET_NATIVE_PROJECT} (${DOTNET_NATIVE_PROJECT_DIR}/timestamp)"
  WORKING_DIRECTORY ${DOTNET_NATIVE_PROJECT_DIR})

add_custom_target(dotnet_native_package
  DEPENDS
    ${DOTNET_NATIVE_PROJECT_DIR}/timestamp
  WORKING_DIRECTORY ${DOTNET_NATIVE_PROJECT_DIR})

####################
##  .Net Package  ##
####################
configure_file(
  ${PROJECT_SOURCE_DIR}/dotnet/${DOTNET_PROJECT}.csproj.in
  ${DOTNET_PROJECT_DIR}/${DOTNET_PROJECT}.csproj.in
  @ONLY)

add_custom_command(
  OUTPUT ${DOTNET_PROJECT_DIR}/${DOTNET_PROJECT}.csproj
  COMMAND ${CMAKE_COMMAND} -E copy ${DOTNET_PROJECT}.csproj.in ${DOTNET_PROJECT}.csproj
  DEPENDS
    ${DOTNET_PROJECT_DIR}/${DOTNET_PROJECT}.csproj.in
  WORKING_DIRECTORY ${DOTNET_PROJECT_DIR})

add_custom_command(
  OUTPUT ${DOTNET_PROJECT_DIR}/timestamp
  COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} build -c Release /p:Platform=${DOTNET_PLATFORM} ${DOTNET_PROJECT}.csproj
  COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} pack -c Release ${DOTNET_PROJECT}.csproj
  COMMAND ${CMAKE_COMMAND} -E touch ${DOTNET_PROJECT_DIR}/timestamp
  DEPENDS
    ${DOTNET_PROJECT_DIR}/${DOTNET_PROJECT}.csproj
    dotnet_native_package
  BYPRODUCTS
    ${DOTNET_PROJECT_DIR}/bin
    ${DOTNET_PROJECT_DIR}/obj
  VERBATIM
  COMMENT "Generate .Net package ${DOTNET_PROJECT} (${DOTNET_PROJECT_DIR}/timestamp)"
  WORKING_DIRECTORY ${DOTNET_PROJECT_DIR})

add_custom_target(dotnet_package ALL
  DEPENDS
    ${DOTNET_PROJECT_DIR}/timestamp
  WORKING_DIRECTORY ${DOTNET_PROJECT_DIR})

#################
##  .Net Test  ##
#################
# add_dotnet_test()
# CMake function to generate and build dotnet test.
# Parameters:
#  the dotnet filename
# e.g.:
# add_dotnet_test(FooTests.cs)
function(add_dotnet_test FILE_NAME)
  message(STATUS "Configuring test ${FILE_NAME} ...")
  get_filename_component(TEST_NAME ${FILE_NAME} NAME_WE)
  get_filename_component(COMPONENT_DIR ${FILE_NAME} DIRECTORY)
  get_filename_component(COMPONENT_NAME ${COMPONENT_DIR} NAME)

  set(DOTNET_TEST_DIR ${PROJECT_BINARY_DIR}/dotnet/${COMPONENT_NAME}/${TEST_NAME})
  message(STATUS "build path: ${DOTNET_TEST_DIR}")

  configure_file(
    ${PROJECT_SOURCE_DIR}/dotnet/Test.csproj.in
    ${DOTNET_TEST_DIR}/${TEST_NAME}.csproj
    @ONLY)

  add_custom_command(
    OUTPUT ${DOTNET_TEST_DIR}/${TEST_NAME}.cs
    COMMAND ${CMAKE_COMMAND} -E make_directory ${DOTNET_TEST_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy
      ${FILE_NAME}
      ${DOTNET_TEST_DIR}/
    MAIN_DEPENDENCY ${FILE_NAME}
    VERBATIM
    WORKING_DIRECTORY ${DOTNET_TEST_DIR})

  add_custom_command(
    OUTPUT ${DOTNET_TEST_DIR}/timestamp
    COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} build -c Release ${TEST_NAME}.csproj
    COMMAND ${CMAKE_COMMAND} -E touch ${DOTNET_TEST_DIR}/timestamp
    DEPENDS
      ${DOTNET_TEST_DIR}/${TEST_NAME}.csproj
      ${DOTNET_TEST_DIR}/${TEST_NAME}.cs
      dotnet_package
    BYPRODUCTS
      ${DOTNET_TEST_DIR}/bin
      ${DOTNET_TEST_DIR}/obj
    VERBATIM
    COMMENT "Compiling .Net ${COMPONENT_NAME}/${TEST_NAME}.cs (${DOTNET_TEST_DIR}/timestamp)"
    WORKING_DIRECTORY ${DOTNET_TEST_DIR})

  add_custom_target(dotnet_${COMPONENT_NAME}_${TEST_NAME} ALL
    DEPENDS
      ${DOTNET_TEST_DIR}/timestamp
    WORKING_DIRECTORY ${DOTNET_TEST_DIR})

  if(BUILD_TESTING)
    add_test(
      NAME dotnet_${COMPONENT_NAME}_${TEST_NAME}
      COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} test --no-build -c Release ${TEST_NAME}.csproj
      WORKING_DIRECTORY ${DOTNET_TEST_DIR})
  endif()
  message(STATUS "Configuring test ${FILE_NAME} done")
endfunction()

####################
##  .Net Example  ##
####################
# add_dotnet_example()
# CMake function to generate and build dotnet example.
# Parameters:
#  the dotnet filename
# e.g.:
# add_dotnet_example(Foo.cs)
function(add_dotnet_example FILE_NAME)
  message(STATUS "Configuring example ${FILE_NAME} ...")
  get_filename_component(EXAMPLE_NAME ${FILE_NAME} NAME_WE)
  get_filename_component(COMPONENT_DIR ${FILE_NAME} DIRECTORY)
  get_filename_component(COMPONENT_NAME ${COMPONENT_DIR} NAME)

  set(DOTNET_EXAMPLE_DIR ${PROJECT_BINARY_DIR}/dotnet/${COMPONENT_NAME}/${EXAMPLE_NAME})
  message(STATUS "build path: ${DOTNET_EXAMPLE_DIR}")

  configure_file(
    ${PROJECT_SOURCE_DIR}/dotnet/Example.csproj.in
    ${DOTNET_EXAMPLE_DIR}/${EXAMPLE_NAME}.csproj
    @ONLY)

  add_custom_command(
    OUTPUT ${DOTNET_EXAMPLE_DIR}/${EXAMPLE_NAME}.cs
    COMMAND ${CMAKE_COMMAND} -E make_directory ${DOTNET_EXAMPLE_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy
      ${FILE_NAME}
      ${DOTNET_EXAMPLE_DIR}/
    MAIN_DEPENDENCY ${FILE_NAME}
    VERBATIM
    WORKING_DIRECTORY ${DOTNET_EXAMPLE_DIR})

  add_custom_command(
    OUTPUT ${DOTNET_EXAMPLE_DIR}/timestamp
    COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} build -c Release ${EXAMPLE_NAME}.csproj
    COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} pack -c Release ${EXAMPLE_NAME}.csproj
    COMMAND ${CMAKE_COMMAND} -E touch ${DOTNET_EXAMPLE_DIR}/timestamp
    DEPENDS
      ${DOTNET_EXAMPLE_DIR}/${EXAMPLE_NAME}.csproj
      ${DOTNET_EXAMPLE_DIR}/${EXAMPLE_NAME}.cs
      dotnet_package
    BYPRODUCTS
      ${DOTNET_EXAMPLE_DIR}/bin
      ${DOTNET_EXAMPLE_DIR}/obj
    VERBATIM
    COMMENT "Compiling .Net ${COMPONENT_NAME}/${EXAMPLE_NAME}.cs (${DOTNET_EXAMPLE_DIR}/timestamp)"
    WORKING_DIRECTORY ${DOTNET_EXAMPLE_DIR})

  add_custom_target(dotnet_${COMPONENT_NAME}_${EXAMPLE_NAME} ALL
    DEPENDS
      ${DOTNET_EXAMPLE_DIR}/timestamp
    WORKING_DIRECTORY ${DOTNET_EXAMPLE_DIR})

  if(BUILD_TESTING)
    if(USE_DOTNET_CORE_31)
      add_test(
        NAME dotnet_${COMPONENT_NAME}_${EXAMPLE_NAME}_netcoreapp31
        COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} run --no-build --framework netcoreapp3.1 -c Release ${EXAMPLE_NAME}.csproj
        WORKING_DIRECTORY ${DOTNET_EXAMPLE_DIR})
    endif()
    if(USE_DOTNET_6)
      add_test(
        NAME dotnet_${COMPONENT_NAME}_${EXAMPLE_NAME}_net60
        COMMAND ${CMAKE_COMMAND} -E env --unset=TARGETNAME ${DOTNET_EXECUTABLE} run --no-build --framework net6.0 -c Release ${EXAMPLE_NAME}.csproj
        WORKING_DIRECTORY ${DOTNET_EXAMPLE_DIR})
    endif()
  endif()
  message(STATUS "Configuring example ${FILE_NAME} done")
endfunction()
