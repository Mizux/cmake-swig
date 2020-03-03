set_property(SOURCE foobar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foobar.i PROPERTY COMPILE_OPTIONS
  -package net.mizux.cmakeswig.foobar
  )
swig_add_library(java_FooBar
  TYPE SHARED
	LANGUAGE java
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/java/net/mizux/cmakeswig/foobar
	SOURCES	foobar.i)

set_property(TARGET java_FooBar PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)
target_include_directories(java_FooBar PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(java_FooBar PRIVATE CMakeSwig::FooBar)
