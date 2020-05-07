set_property(SOURCE foo.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foo.i PROPERTY COMPILE_OPTIONS
  -package ${CMAKE_SWIG_JAVA}.foo)
swig_add_library(jniFoo
	TYPE OBJECT
  LANGUAGE java
  OUTPUT_DIR
	${PROJECT_BINARY_DIR}/java/${CMAKE_SWIG_JAVA}/src/main/java/org/mizux/cmakeswig/foo
  SOURCES foo.i)

set_target_properties(jniFoo PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/java
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(jniFoo PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(jniFoo PRIVATE CMakeSwig::Foo)
