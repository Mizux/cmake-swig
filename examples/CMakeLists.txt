if(NOT BUILD_EXAMPLES)
  return()
endif()

file(GLOB CPP_SRCS "*.cpp")
foreach(EXAMPLE IN LISTS CPP_SRCS)
  add_cpp_example(${EXAMPLE})
endforeach()
