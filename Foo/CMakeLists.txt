add_library(Foo "")

target_sources(Foo
  PRIVATE
    include/foo/Foo.hpp
    src/Foo.cpp)
target_include_directories(Foo
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)
target_compile_features(Foo PUBLIC cxx_std_11)
set_target_properties(Foo PROPERTIES
  VERSION ${PROJECT_VERSION}
  PUBLIC_HEADER include/foo/Foo.hpp)
#target_link_libraries(Foo PUBLIC ...)
add_library(${PROJECT_NAME}::Foo ALIAS Foo)

if(BUILD_TESTING)
  add_subdirectory(test)
endif()

# Install
include(GNUInstallDirs)
install(TARGETS Foo
  EXPORT ${PROJECT_NAME}Targets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foo
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )
