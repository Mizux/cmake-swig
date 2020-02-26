# SWIG Wrapper Generation
Using [swig](https://github.com/swig/swig) to generate wrapper it's easy thanks to the modern
[UseSWIG](https://cmake.org/cmake/help/latest/module/UseSWIG.html) module (**CMake >= 3.14**).

note: SWIG automatically put its target(s) in `all`, thus `cmake --build build` will also call
swig and generate `_module.so`.

# Policy
UseSWIG is impacted by two policies:
* [CMP0078](https://cmake.org/cmake/help/latest/policy/CMP0078.html):UseSWIG generates standard target names (CMake 3.13+).
* [CMP0086](https://cmake.org/cmake/help/latest/policy/CMP0086.html): UseSWIG honors `SWIG_MODULE_NAME` via `-module` flag (CMake 3.14+).

That's why I recommnend to use CMake >= 3.14 with both policies set to new for
SWIG development.

# swig_add_library()
You can use `CMAKE_SWIG_DIR` to change the output directory for the `.py` file e.g.:
```cmake
set(CMAKE_SWIG_OUTDIR ${CMAKE_CURRENT_BINARY_DIR}/..)
```
And you can use `CMAKE_LIBRARY_OUTPUT_DIRECTORY` to change the output directory for the `.so` file e.g.:
```cmake
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/..)
```
[optional]You can use `SWIG_OUTFILE_DIR` to change the output directory for the `.cxx` file e.g.:
```cmake
set(SWIG_OUTFILE_DIR ${CMAKE_CURRENT_BINARY_DIR}/..)
```


# Doxygen
Since swig 4.0, swig can now extract doxygen comment from C++ to inject it in
Python/Java.

## Csharp documentation
note: Doxygen to csharp was [planned](https://github.com/swig/swig/wiki/SWIG-4.0-Development#doxygen-documentation) but currently is not supported.
