set_property(SOURCE foo.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foo.i PROPERTY COMPILE_OPTIONS
  -package net.mizux.cmakeswig.foo)
swig_add_library(java_Foo
  TYPE SHARED
	LANGUAGE java
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/java/net/mizux/cmakeswig/foo
	SOURCES	foo.i)

set_target_properties(java_Foo PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/java
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(java_Foo PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(java_Foo PRIVATE CMakeSwig::Foo)
