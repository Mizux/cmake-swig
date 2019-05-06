add_executable(FooBarApp "")
target_sources(FooBarApp
  PRIVATE
  src/main.cpp
)
set_target_properties(FooBarApp PROPERTIES
  VERSION ${PROJECT_VERSION})
# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(FooBarApp PROPERTIES
    INSTALL_RPATH "@loader_path/../lib")
elseif(UNIX AND NOT APPLE)
  set_target_properties(FooBarApp PROPERTIES
		INSTALL_RPATH "$ORIGIN/../lib")
endif()
target_link_libraries(FooBarApp
  PRIVATE
    CMakeSwig::FooBar
)
add_executable(CMakeSwig::FooBarApp ALIAS FooBarApp)

add_test(NAME FooBarAppTest COMMAND FooBarApp)

# Install
include(GNUInstallDirs)
install(TARGETS FooBarApp
	EXPORT CMakeSwigTargets
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
