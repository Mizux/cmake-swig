set_property(SOURCE foobar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foobar.i PROPERTY COMPILE_OPTIONS
  -package ${JAVA_PACKAGE}.foobar)
swig_add_library(jniFooBar
  TYPE OBJECT
  LANGUAGE java
  OUTPUT_DIR
  ${PROJECT_BINARY_DIR}/java/${JAVA_PROJECT}/${JAVA_PACKAGE_PATH}/foobar
  SOURCES foobar.i)

set_target_properties(jniFooBar PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/java
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(jniFooBar PRIVATE ${JNI_INCLUDE_DIRS})
target_link_libraries(jniFooBar PRIVATE CMakeSwig::FooBar)
