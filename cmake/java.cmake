if(NOT BUILD_JAVA)
  return()
endif()

if(NOT TARGET CMakeSwig::FooBar)
  message(FATAL_ERROR "Python: missing FooBar TARGET")
endif()

# Find java
find_package(Java COMPONENTS Development REQUIRED)
message(STATUS "Found Java: ${Java_JAVA_EXECUTABLE} (found version \"${Java_VERSION_STRING}\")")

find_package(JNI REQUIRED)
message(STATUS "Found JNI: ${JNI_FOUND}")

