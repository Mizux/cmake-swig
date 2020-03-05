set_property(SOURCE foo.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foo.i PROPERTY COMPILE_OPTIONS
  -namespace ${CMAKE_SWIG_DOTNET}.Foo
  -dllimport mizux-cmakeswig-native)
swig_add_library(dotnet_Foo
	TYPE OBJECT
	LANGUAGE csharp
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/dotnet/${PROJECT_NAME}/Foo
	SOURCES	foo.i)
set_target_properties(dotnet_Foo PROPERTIES
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
  POSITION_INDEPENDENT_CODE ON)
target_link_libraries(dotnet_Foo PRIVATE CMakeSwig::Foo)
