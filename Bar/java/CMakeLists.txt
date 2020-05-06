set_property(SOURCE bar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE bar.i PROPERTY COMPILE_OPTIONS
  -package org.mizux.cmake-swig.bar)
swig_add_library(java_Bar
  TYPE SHARED
  LANGUAGE java
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/java/org/mizux/cmake-swig/bar
  SOURCES bar.i)

set_target_properties(java_Bar PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/java
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(java_Bar PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(java_Bar PRIVATE CMakeSwig::Bar)
