if(NOT BUILD_TESTING)
  return()
endif()

file(GLOB PYTHON_SRCS "*.py")
foreach(FILE_NAME IN LISTS PYTHON_SRCS)
  add_python_test(${FILE_NAME})
endforeach()
