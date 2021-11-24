| OS     | C++ | Python | Java | .NET |
|:-------|-----|--------|------|------|
| Linux  | [![Status][cpp_linux_svg]][cpp_linux_link] | [![Status][python_linux_svg]][python_linux_link] | [![Status][java_linux_svg]][java_linux_link] | [![Status][dotnet_linux_svg]][dotnet_linux_link] |
| macOS  | [![Status][cpp_osx_svg]][cpp_osx_link] | [![Status][python_osx_svg]][python_osx_link] | [![Status][java_osx_svg]][java_osx_link] | [![Status][dotnet_osx_svg]][dotnet_osx_link] |
| Windows  | [![Status][cpp_win_svg]][cpp_win_link] | [![Status][python_win_svg]][python_win_link] | [![Status][java_win_svg]][java_win_link] | [![Status][dotnet_win_svg]][dotnet_win_link] |


[cpp_linux_svg]: https://github.com/Mizux/cmake-swig/workflows/C++%20Linux%20CI/badge.svg?branch=master
[cpp_linux_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"C%2B%2B+Linux+CI"
[python_linux_svg]: https://github.com/Mizux/cmake-swig/workflows/Python%20Linux%20CI/badge.svg?branch=master
[python_linux_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Python+Linux+CI"
[java_linux_svg]: https://github.com/Mizux/cmake-swig/workflows/Java%20Linux%20CI/badge.svg?branch=master
[java_linux_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Java+Linux+CI"
[dotnet_linux_svg]: https://github.com/Mizux/cmake-swig/workflows/.Net%20Linux%20CI/badge.svg?branch=master
[dotnet_linux_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A".Net+Linux+CI"

[cpp_osx_svg]: https://github.com/Mizux/cmake-swig/workflows/C++%20MacOS%20CI/badge.svg?branch=master
[cpp_osx_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"C%2B%2B+MacOS+CI"
[python_osx_svg]: https://github.com/Mizux/cmake-swig/workflows/Python%20MacOS%20CI/badge.svg?branch=master
[python_osx_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Python+MacOS+CI"
[java_osx_svg]: https://github.com/Mizux/cmake-swig/workflows/Java%20MacOS%20CI/badge.svg?branch=master
[java_osx_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Java+MacOS+CI"
[dotnet_osx_svg]: https://github.com/Mizux/cmake-swig/workflows/.Net%20MacOS%20CI/badge.svg?branch=master
[dotnet_osx_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A".Net+MacOS+CI"

[cpp_win_svg]: https://github.com/Mizux/cmake-swig/workflows/C++%20Windows%20CI/badge.svg?branch=master
[cpp_win_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"C%2B%2B+Windows+CI"
[python_win_svg]: https://github.com/Mizux/cmake-swig/workflows/Python%20Windows%20CI/badge.svg?branch=master
[python_win_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Python+Windows+CI"
[java_win_svg]: https://github.com/Mizux/cmake-swig/workflows/Java%20Windows%20CI/badge.svg?branch=master
[java_win_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Java+Windows+CI"
[dotnet_win_svg]: https://github.com/Mizux/cmake-swig/workflows/.Net%20Windows%20CI/badge.svg?branch=master
[dotnet_win_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A".Net+Windows+CI"

[![Build Status][docker_status]][docker_link]
[![Build Status][travis_status]][travis_link]
[![Build Status][appveyor_status]][appveyor_link]

[docker_status]: https://github.com/Mizux/cmake-swig/workflows/Docker/badge.svg?branch=master
[docker_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"Docker"

[travis_status]: https://travis-ci.com/Mizux/cmake-swig.svg?branch=master
[travis_link]: https://travis-ci.com/Mizux/cmake-swig

[appveyor_status]: https://ci.appveyor.com/api/projects/status/a8pir5oh0gpt2q5u/branch/master?svg=true
[appveyor_link]: https://ci.appveyor.com/project/Mizux/cmake-swig/branch/master

# Introduction
<nav for="project"> |
<a href="#requirement">Requirement</a> |
<a href="#codemap">Codemap</a> |
<a href="#dependencies">Dependencies</a> |
<a href="#build">Build</a> |
<a href="docs/cpp.md">C++</a> |
<a href="docs/swig.md">Swig</a> |
<a href="docs/python.md">Python 3</a> |
<a href="docs/dotnet.md">.Net Core</a> |
<a href="docs/java.md">Java</a> |
<a href="ci/README.md">CI</a> |
<a href="#appendices">Appendices</a> |
<a href="#license">License</a> |
</nav>

This is a complete example of how to create a Modern [CMake](https://cmake.org/) C++ Project
with the [SWIG](http://www.swig.org) code generator to generate wrapper and package for Python, .Net and Java.  

This project should run on GNU/Linux, MacOS and Windows.

You can find detailed documentation for [C++](docs/cpp.md), [Swig](docs/swig.md),
[Python 3](docs/python.md), [.Net Core](docs/dotnet.md) and [Java](docs/java.md).

note: You should read **C++** and **Swig** first since since other languages are
just swig generated wrappers from the C++.

## Requirement
You'll need:

* "CMake >= 3.18".
* "Python >= 3.6" and python module 'pip' (ed "setuptools" and "wheel" will be
 auto installed on demand).

## Codemap
The project layout is as follow:

* [CMakeLists.txt](CMakeLists.txt) Top-level for [CMake](https://cmake.org/cmake/help/latest/) based build.
* [cmake](cmake) Subsidiary CMake files.
  * [python.cmake](cmake/python.cmake) All internall Python CMake stuff.
  * [dotnet.cmake](cmake/dotnet.cmake) All internall .Net CMake stuff.
  * [java.cmake](cmake/java.cmake) All internall Java CMake stuff.

* [ci](ci) Root directory for continuous integration.

* [Foo](Foo) Root directory for `Foo` library.
  * [CMakeLists.txt](Foo/CMakeLists.txt) for `Foo`.
  * [include](Foo/include) public folder.
    * [foo](Foo/include/foo)
      * [Foo.hpp](Foo/include/foo/Foo.hpp)
  * [src](Foo/src) private folder.
    * [src/Foo.cpp](Foo/src/Foo.cpp)
  * [python](Foo/python)
    * [CMakeLists.txt](Foo/python/CMakeLists.txt) for `Foo` Python.
    * [foo.i](Foo/python/foo.i) SWIG Python wrapper.
  * [dotnet](Foo/dotnet)
    * [CMakeLists.txt](Foo/dotnet/CMakeLists.txt) for `Foo` .Net.
    * [foo.i](Foo/dotnet/foo.i) SWIG .Net wrapper.
  * [java](Foo/java)
    * [CMakeLists.txt](Foo/java/CMakeLists.txt) for `Foo` Java.
    * [java/foo.i](Foo/java/foo.i) SWIG Java wrapper.
* [Bar](Bar) Root directory for `Bar` library.
  * [CMakeLists.txt](Bar/CMakeLists.txt) for `Bar`.
  * [include](Bar/include) public folder.
    * [bar](Bar/include/bar)
      * [Bar.hpp](Bar/include/bar/Bar.hpp)
  * [src](Bar/src) private folder.
    * [src/Bar.cpp](Bar/src/Bar.cpp)
  * [python](Bar/python)
    * [CMakeLists.txt](Bar/python/CMakeLists.txt) for `Bar` Python.
    * [bar.i](Bar/python/bar.i) SWIG Python wrapper.
  * [dotnet](Bar/dotnet)
    * [CMakeLists.txt](Bar/dotnet/CMakeLists.txt) for `Bar` .Net.
    * [bar.i](Bar/dotnet/bar.i) SWIG .Net wrapper.
  * [java](Bar/java)
    * [CMakeLists.txt](Bar/java/CMakeLists.txt) for `Bar` Java.
    * [java/bar.i](Bar/java/bar.i) SWIG Java wrapper.
* [FooBar](FooBar) Root directory for `FooBar` library.
  * [CMakeLists.txt](FooBar/CMakeLists.txt) for `FooBar`.
  * [include](FooBar/include) public folder.
    * [foobar](FooBar/include/foobar)
      * [FooBar.hpp](FooBar/include/foobar/FooBar.hpp)
  * [src](FooBar/src) private folder.
    * [src/FooBar.cpp](FooBar/src/FooBar.cpp)
  * [python](FooBar/python)
    * [CMakeLists.txt](FooBar/python/CMakeLists.txt) for `FooBar` Python.
    * [foobar.i](FooBar/python/foobar.i) SWIG Python wrapper.
  * [dotnet](FooBar/dotnet)
    * [CMakeLists.txt](FooBar/dotnet/CMakeLists.txt) for `FooBar` .Net.
    * [foobar.i](FooBar/dotnet/foobar.i) SWIG .Net wrapper.
  * [java](FooBar/java)
    * [CMakeLists.txt](FooBar/java/CMakeLists.txt) for `FooBar` Java.
    * [java/foobar.i](FooBar/java/foobar.i) SWIG Java wrapper.
* [FooBarApp](FooBarApp) Root directory for `FooBarApp` executable.
  * [CMakeLists.txt](FooBarApp/CMakeLists.txt) for `FooBarApp`.
  * [src](FooBarApp/src) private folder.
    * [src/main.cpp](FooBarApp/src/main.cpp)

* [python](python) Root directory for Python template files
  * [`setup.py.in`](python/setup.py.in) setup.py template for the Python native package.
* [dotnet](dotnet) Root directory for .Net template files
* [java](java) Root directory for Java template files

## Dependencies
To complexify a little, the CMake project is composed of three libraries (Foo, Bar and FooBar)
with the following dependencies:  
```sh
Foo:
Bar:
FooBar: PUBLIC Foo PRIVATE Bar
```

## Build
To build the C++ project, as usual:
```sh
cmake -S. -Bbuild
cmake --build build
```

## Appendices
Few links on the subject...

### Resources
Project layout:
* The Pitchfork Layout Revision 1 (cxx-pflR1)

CMake:
* https://llvm.org/docs/CMakePrimer.html
* https://cliutils.gitlab.io/modern-cmake/
* https://cgold.readthedocs.io/en/latest/

Python:
* [Packaging Python Project](https://packaging.python.org/tutorials/packaging-projects/)
* [PEP 600  Future 'manylinux' Platform Tags](https://www.python.org/dev/peps/pep-0600/)

### Misc
Image has been generated using [plantuml](http://plantuml.com/):
```bash
plantuml -Tsvg docs/{file}.dot
```
So you can find the dot source files in [docs](docs).

## License
Apache 2. See the LICENSE file for details.

## Disclaimer
This is not an official Google product, it is just code that happens to be
owned by Google.

