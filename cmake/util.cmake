# Usage find_package(TARGET_PACKAGE [PACKAGE OPTIONS]).
# e.g.: find_package(Protobuf REQUIRED)
macro(find_package TARGET_PACKAGE)
  if(TARGET CMakeSwig::${TARGET_PACKAGE})
		get_target_property(TGT_VERSION CMakeSwig::${TARGET_PACKAGE} VERSION)
		message(STATUS "Found Target: CMakeSwig::${TARGET_PACKAGE} (found version \"${TGT_VERSION}\")")
    set(${TARGET_PACKAGE}_FOUND TRUE PARENT_SCOPE)
	else()
		_find_package(${TARGET_PACKAGE} ${ARGN})
	endif()
endmacro()

