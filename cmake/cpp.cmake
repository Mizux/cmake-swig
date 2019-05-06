if(NOT BUILD_CXX)
  return()
endif()

add_subdirectory(Foo)
add_subdirectory(Bar)
add_subdirectory(FooBar)
add_subdirectory(FooBarApp)

# Install
include(GNUInstallDirs)
install(EXPORT CMakeSwigTargets
  NAMESPACE CMakeSwig::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig
  COMPONENT Devel)
include(CMakePackageConfigHelpers)
configure_package_config_file(cmake/CMakeSwigConfig.cmake.in
  "${PROJECT_BINARY_DIR}/CMakeSwigConfig.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/CMakeSwigConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion)
install(
  FILES
  "${PROJECT_BINARY_DIR}/CMakeSwigConfig.cmake"
  "${PROJECT_BINARY_DIR}/CMakeSwigConfigVersion.cmake"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig"
  COMPONENT Devel)
