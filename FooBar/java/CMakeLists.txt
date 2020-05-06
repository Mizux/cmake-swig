set_property(SOURCE foobar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foobar.i PROPERTY COMPILE_OPTIONS
  -package org.mizux.cmake-swig.foobar)
swig_add_library(java_FooBar
  TYPE SHARED
  LANGUAGE java
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/java/org/mizux/cmake-swig/foobar
  SOURCES foobar.i)

set_target_properties(java_FooBar PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/java
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(java_FooBar PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(java_FooBar PRIVATE CMakeSwig::FooBar)
