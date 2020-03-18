set(NAME Bar_UT)

file(GLOB _SRCS "src/*.[hc]pp")

add_executable(${NAME}
  src/main.cpp
  src/Bar_UT.cpp
  )
# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(${NAME} PROPERTIES
    INSTALL_RPATH "@loader_path/../lib")
elseif(UNIX AND NOT APPLE)
  set_target_properties(${NAME} PROPERTIES
    INSTALL_RPATH "$ORIGIN/../lib")
endif()
target_link_libraries(${NAME}
  PRIVATE
    Catch2 CMakeSwig::Bar)
add_test(NAME ${NAME} COMMAND ${NAME})
