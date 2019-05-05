# outdir for .so file
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/..)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/..)
# Second, for multi-config builds (e.g. msvc)
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
	string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR}/..)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR}/..)
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_CURRENT_BINARY_DIR}/..)
endforeach()

set_property(SOURCE bar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE bar.i PROPERTY SWIG_MODULE_NAME pyBar)
swig_add_library(pyBar
	LANGUAGE python
	OUTPUT_DIR ..
	SOURCES bar.i)
set_property(TARGET pyBar PROPERTY
	SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON
)
target_include_directories(pyBar
	PRIVATE
	  ../include
	  ${PYTHON_INCLUDE_DIRS}
)
# note: macOS is APPLE and also UNIX !
if(APPLE)
	set_target_properties(pyBar PROPERTIES
		SUFFIX ".so"
		INSTALL_RPATH "@loader_path"
  )
	set_property(TARGET pyBar APPEND PROPERTY
		LINK_FLAGS "-flat_namespace -undefined suppress"
	)
elseif(UNIX)
	set_target_properties(pyBar PROPERTIES
		INSTALL_RPATH "$ORIGIN"
	)
endif()
target_link_libraries(pyBar
	PRIVATE
	  Bar
		${PYTHON_LIBRARIES}
)
