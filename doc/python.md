| Linux | macOS | Windows |
|-------|-------|---------|
| [![Status][python_linux_svg]][python_linux_link] | [![Status][python_osx_svg]][python_osx_link] | [![Status][python_win_svg]][python_win_link] |

[python_linux_svg]: https://github.com/Mizux/cmake-swig/workflows/Python%20Linux%20CI/badge.svg
[python_linux_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Python+Linux+CI"
[python_osx_svg]: https://github.com/Mizux/cmake-swig/workflows/Python%20MacOS%20CI/badge.svg
[python_osx_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Python+MacOS+CI"
[python_win_svg]: https://github.com/Mizux/cmake-swig/workflows/Python%20Windows%20CI/badge.svg
[python_win_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Python+Windows+CI"


# Python Wrapper Status
- [x] GNU/Linux wrapper
- [x] MacOS wrapper
- [x] Windows wrapper

# Introduction 
To be compliant with [PEP513](https://www.python.org/dev/peps/pep-0513/#the-manylinux1-policy) a python package should embbed all its C++ shared libraries.

Creating a Python native package containing all `.py` and `.so` (with good rpath/loaderpath) is not so easy... 

# Build the Binary Package
To build the Python wheel package, simply run:
```sh
cmake -S. -Bbuild -DBUILD_PYTHON=ON
cmake --build build --target python_package
```

## Build directory layout
Since Python use the directory name where `__init__.py` file is located and we
want to use the [CMAKE_BINARY_DIR](https://cmake.org/cmake/help/latest/variable/CMAKE_BINARY_DIR.html) 
to generate the Python binary package.  

We want this layout (`tree build --prune -U -P "*.py|*.so*" -I "build"`):
```shell
build/python
├── setup.py
└── CMakeSwig
    ├── __init__.py
    ├── FooBar
    │   ├── __init__.py
    │   ├── _pyFooBar.so
    │   └── pyFooBar.py
    ├── Foo
    │   ├── __init__.py
    │   ├── pyFoo.py
    │   └── _pyFoo.so
    ├── Bar
    │   ├── __init__.py
    │   ├── _pyBar.so
    │   └── pyBar.py
    └── .libs
        ├── libBar.so.1.0
        ├── libFooBar.so.1.0
        └── libFoo.so.1.0
```
note: on Windows since we are using static libraries we won't have the `.libs` directory...

## Managing SWIG generated files
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
Then you only need to create a `__init__.py` file in `build/Foo` to be able to use
the build directory to generate the Python package.

note: you allways need `$ORIGIN/../${PROJECT_NAME}/.libs` since `_pyFoo.so` will depend on `libFoo.so`
(which will be built in the same directory see above).

### Why setup.py has to be generated
To avoid to put hardcoded path to SWIG `.so/.dylib` generated files,
we could use `$<TARGET_FILE_NAME:tgt>` to retrieve the file (and also deal with Mac/Windows suffix, and target dependencies).  
In order for setup.py to use
[cmake generator expression](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#informational-expressions)
(e.g. $<TARGET_FILE_NAME:_pyFoo>). We need to generate it at build time (e.g. using
[add_custom_command()](https://cmake.org/cmake/help/latest/command/add_custom_command.html)).  
note: This will also add automatically a dependency between the command and the TARGET !

todo(mizux): try to use [`file(GENERATE ...)`](https://cmake.org/cmake/help/latest/command/file.html#generate) instead.

# Testing Python
## Testing using virtualenv

