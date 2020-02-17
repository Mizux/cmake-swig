if(NOT BUILD_JAVA)
  return()
endif()

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR "Java: missing FooBar TARGET")
endif()

# Will need swig
find_package(SWIG REQUIRED)
include(UseSWIG)

# Find java
find_package(Java COMPONENTS Development REQUIRED)
message(STATUS "Found Java: ${Java_JAVA_EXECUTABLE} (found version \"${Java_VERSION_STRING}\")")

find_package(JNI REQUIRED)
message(STATUS "Found JNI: ${JNI_FOUND}")

