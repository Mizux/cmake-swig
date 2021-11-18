add_library(Bar "")

target_sources(Bar
  PRIVATE
    include/bar/Bar.hpp
    src/Bar.cpp)
target_include_directories(Bar
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)
target_compile_features(Bar PUBLIC cxx_std_17)
set_target_properties(Bar PROPERTIES
  VERSION ${PROJECT_VERSION}
  PUBLIC_HEADER include/bar/Bar.hpp)
#target_link_libraries(Bar PUBLIC ...)
add_library(${PROJECT_NAMESPACE}::Bar ALIAS Bar)

add_subdirectory(tests)

# Install
include(GNUInstallDirs)
install(TARGETS Bar
  EXPORT ${PROJECT_NAME}Targets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/bar
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
