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

set_property(SOURCE foo.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE foo.i PROPERTY SWIG_MODULE_NAME pyFoo)
swig_add_library(pyFoo
	TYPE SHARED
	LANGUAGE python
	OUTPUT_DIR ..
	SOURCES	foo.i)

target_include_directories(pyFoo
	PRIVATE
		../include
		${PYTHON_INCLUDE_DIRS}
)
set_property(TARGET pyFoo PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)

# note: macOS is APPLE and also UNIX !
if(APPLE)
	set_target_properties(pyFoo PROPERTIES
		SUFFIX ".so"
		INSTALL_RPATH	"@loader_path"
	)
	set_property(TARGET pyFoo APPEND PROPERTY
		LINK_FLAGS "-flat_namespace -undefined suppress"
	)
elseif(UNIX)
	set_target_properties(pyFoo PROPERTIES
		INSTALL_RPATH	"$ORIGIN"
	)
endif()

target_link_libraries(pyFoo
	PRIVATE
		Foo
		${PYTHON_LIBRARIES}
)
