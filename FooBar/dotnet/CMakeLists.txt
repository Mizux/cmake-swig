set_property(SOURCE foobar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foobar.i PROPERTY COMPILE_OPTIONS
  -namespace Mizux.CMakeSwig.FooBar
  -dllimport mizux-cmakeswig-native
  )
swig_add_library(dotnet_foobar
	TYPE OBJECT
	LANGUAGE csharp
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/dotnet/${PROJECT_NAME}/FooBar
	SOURCES	foobar.i)

set_property(TARGET dotnet_foobar PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)
target_link_libraries(dotnet_foobar PRIVATE CMakeSwig::FooBar)
