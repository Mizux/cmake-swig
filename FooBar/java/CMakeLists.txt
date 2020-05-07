set_property(SOURCE foobar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foobar.i PROPERTY COMPILE_OPTIONS
  -package ${CMAKE_SWIG_JAVA}.foobar)
swig_add_library(jniFooBar
  TYPE OBJECT
  LANGUAGE java
  OUTPUT_DIR
	${PROJECT_BINARY_DIR}/java/${CMAKE_SWIG_JAVA}/src/main/java/org/mizux/cmakeswig/foobar
  SOURCES foobar.i)

set_target_properties(jniFooBar PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/java
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(jniFooBar PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(jniFooBar PRIVATE CMakeSwig::FooBar)
