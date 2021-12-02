set_property(SOURCE bar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE bar.i PROPERTY COMPILE_OPTIONS
  -namespace ${DOTNET_PROJECT}.Bar
  -dllimport mizux-cmakeswig-native)
swig_add_library(dotnet_Bar
  TYPE OBJECT
  LANGUAGE csharp
  OUTPUT_DIR ${DOTNET_PROJECT_DIR}/Bar
  SOURCES bar.i)

set_target_properties(dotnet_Bar PROPERTIES
  SWIG_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/dotnet
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_link_libraries(dotnet_Bar PRIVATE ${PROJECT_NAMESPACE}::Bar)
