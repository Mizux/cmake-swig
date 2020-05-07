set_property(SOURCE bar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE bar.i PROPERTY COMPILE_OPTIONS
	-package ${CMAKE_SWIG_JAVA}.bar)
swig_add_library(jniBar
  TYPE OBJECT
  LANGUAGE java
  OUTPUT_DIR
	${PROJECT_BINARY_DIR}/java/${CMAKE_SWIG_JAVA}/src/main/java/org/mizux/cmakeswig/bar
  SOURCES bar.i)

set_target_properties(jniBar PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/java
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(jniBar PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(jniBar PRIVATE CMakeSwig::Bar)
