if(NOT BUILD_TESTING)
  return()
endif()

file(GLOB CPP_SRCS "*.cpp")
foreach(TEST IN LISTS CPP_SRCS)
  add_cpp_test(${TEST})
endforeach()
