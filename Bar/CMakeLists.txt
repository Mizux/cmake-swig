cmake_minimum_required(VERSION 3.8.2)
project(Bar)

add_library(Bar src/Bar.cpp)
target_include_directories(Bar PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:include>)
set_target_properties(Bar PROPERTIES PUBLIC_HEADER "include/bar/Bar.hpp")
#target_link_libraries(${PROJECT_NAME} PUBLIC ...)
add_library(Bar::Bar ALIAS Bar)

# Python Wrapper
add_subdirectory(python)

# install rules
include(GNUInstallDirs)
install(TARGETS Bar
	EXPORT ${PROJECT_NAME}Targets
	INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/bar
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	#RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
install(EXPORT BarTargets
	NAMESPACE Bar::
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Bar)
