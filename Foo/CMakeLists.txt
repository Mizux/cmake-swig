project(Foo VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
  # Second, for multi-config builds (e.g. msvc)
  foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR})
  endforeach()
endif()

add_library(${PROJECT_NAME} src/Foo.cpp)
target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)
set_target_properties(${PROJECT_NAME} PROPERTIES
  VERSION ${PROJECT_VERSION}
  PUBLIC_HEADER "include/foo/Foo.hpp")
#target_link_libraries(${PROJECT_NAME} PUBLIC ...)
add_library(CMakeSwig::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Python Wrapper
if(BUILD_PYTHON)
  add_subdirectory(python)
endif()
# .Net Wrapper
if(BUILD_DOTNET)
  add_subdirectory(dotnet)
endif()
# Java Wrapper
if(BUILD_JAVA)
  add_subdirectory(java)
endif()

# Install
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
  EXPORT CMakeSwigTargets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foo
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )
