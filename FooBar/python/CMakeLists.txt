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

set_property(SOURCE foobar.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foobar.i PROPERTY SWIG_MODULE_NAME pyFooBar)
swig_add_library(pyFooBar
	LANGUAGE python
	OUTPUT_DIR ..
	SOURCES foobar.i)
set_property(TARGET pyFooBar PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)
target_include_directories(pyFooBar
	PRIVATE
	../include
	${PYTHON_INCLUDE_DIRS}
	)
# note: macOS is APPLE and also UNIX !
if(APPLE)
	set_target_properties(pyFooBar PROPERTIES
		SUFFIX ".so"
		INSTALL_RPATH "@loader_path"
		)
	set_property(TARGET pyFooBar APPEND PROPERTY
		LINK_FLAGS "-flat_namespace -undefined suppress"
		)
elseif(UNIX)
	set_target_properties(pyFooBar PROPERTIES
		INSTALL_RPATH "$ORIGIN"
		)
endif()
target_link_libraries(pyFooBar
	PRIVATE
	FooBar
	${PYTHON_LIBRARIES}
	)
