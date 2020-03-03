set_property(SOURCE foo.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foo.i PROPERTY COMPILE_OPTIONS
  -package net.mizux.cmakeswig.foo
  )
swig_add_library(java_Foo
  TYPE SHARED
	LANGUAGE java
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/java/net/mizux/cmakeswig/foo
	SOURCES	foo.i)

set_property(TARGET java_Foo PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)
target_link_libraries(java_Foo PRIVATE CMakeSwig::Foo)
