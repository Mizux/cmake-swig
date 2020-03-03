set_property(SOURCE bar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE bar.i PROPERTY COMPILE_OPTIONS
  -package net.mizux.cmakeswig.bar
  )
swig_add_library(java_Bar
  TYPE SHARED
	LANGUAGE java
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/java/net/mizux/cmakeswig/bar
	SOURCES	bar.i)

set_property(TARGET java_Bar PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)
target_link_libraries(java_Bar PRIVATE CMakeSwig::Bar)
