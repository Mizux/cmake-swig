cmake_minimum_required(VERSION 3.8.2)
project(FooBar VERSION 1.0.0 LANGUAGES CXX)

find_package(Foo REQUIRED)
find_package(Bar REQUIRED)

#add_executable(FooBar src/main.cpp src/FooBar.cpp)
add_library(FooBar src/FooBar.cpp)
target_include_directories(FooBar PRIVATE
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:include>
	)
set_target_properties(FooBar PROPERTIES PUBLIC_HEADER "include/foobar/FooBar.hpp")
if(APPLE)
set_target_properties(${PROJECT_NAME} PROPERTIES
	INSTALL_RPATH "@loader_path/../Foo;@loader_path/../Bar;@loader_path/../lib")
elseif(UNIX AND NOT APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
INSTALL_RPATH "$ORIGIN/../Foo:$ORIGIN/../Bar:$ORIGIN")
endif()
target_link_libraries(FooBar PRIVATE Foo::Foo Bar::Bar)
add_library(FooBar::FooBar ALIAS FooBar)

# Add Python Wrapper
add_subdirectory(python)

# install rules
include(GNUInstallDirs)
install(TARGETS FooBar
	EXPORT FooBarTargets
	INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foobar
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	#RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
install(EXPORT FooBarTargets
	NAMESPACE FooBar::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FooBar
	)
