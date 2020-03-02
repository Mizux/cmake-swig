set_property(SOURCE bar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE bar.i PROPERTY COMPILE_OPTIONS
  -namespace Mizux.CMakeSwig.Bar
  -dllimport mizux-cmakeswig-native
  )
swig_add_library(dotnet_bar
	TYPE OBJECT
	LANGUAGE csharp
  OUTPUT_DIR ${PROJECT_BINARY_DIR}/dotnet/${PROJECT_NAME}/Bar
	SOURCES	bar.i)

set_property(TARGET dotnet_bar PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)
target_link_libraries(dotnet_bar PRIVATE CMakeSwig::Bar)
