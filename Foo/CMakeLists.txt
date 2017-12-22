cmake_minimum_required(VERSION 3.8.2)
project(Foo VERSION 1.0.0 LANGUAGES CXX)

add_library(Foo src/Foo.cpp)
target_include_directories(Foo PUBLIC
	$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:include>)
set_target_properties(Foo PROPERTIES PUBLIC_HEADER "include/foo/Foo.hpp")
#target_link_libraries(${PROJECT_NAME} PUBLIC ...)
add_library(Foo::Foo ALIAS Foo)

# Python Wrapper
add_subdirectory(python)

# install rules
include(GNUInstallDirs)
install(TARGETS Foo
	EXPORT FooTargets
	INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foo
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	#RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
install(EXPORT FooTargets
	NAMESPACE Foo::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Foo
	)
