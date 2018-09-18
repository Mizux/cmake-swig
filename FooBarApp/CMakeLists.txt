project(FooBarApp VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
# Second, for multi-config builds (e.g. msvc)
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR})
endforeach()
endif()

find_package(FooBar CONFIG REQUIRED)

add_executable(${PROJECT_NAME} src/main.cpp)
if(APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
    INSTALL_RPATH "@loader_path/../lib")
elseif(UNIX AND NOT APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES
		INSTALL_RPATH "$ORIGIN/../lib")
endif()
set_target_properties(${PROJECT_NAME} PROPERTIES
  VERSION ${PROJECT_VERSION})
target_link_libraries(${PROJECT_NAME} PRIVATE CMakeSwig::FooBar)
add_executable(CMakeSwig::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Install
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
	EXPORT CMakeSwigTargets
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
