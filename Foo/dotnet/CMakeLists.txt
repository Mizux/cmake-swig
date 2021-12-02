set_property(SOURCE foo.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foo.i PROPERTY COMPILE_OPTIONS
  -namespace ${DOTNET_PROJECT}.Foo
  -dllimport mizux-cmakeswig-native)
swig_add_library(dotnet_Foo
  TYPE OBJECT
  LANGUAGE csharp
  OUTPUT_DIR ${DOTNET_PROJECT_DIR}/Foo
  SOURCES foo.i)

set_target_properties(dotnet_Foo PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/dotnet
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_link_libraries(dotnet_Foo PRIVATE ${PROJECT_NAMESPACE}::Foo)
