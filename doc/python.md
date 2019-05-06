# Python Wrapper
## Build directory layout
Since we want to use the [CMAKE_BINARY_DIR](https://cmake.org/cmake/help/latest/variable/CMAKE_BINARY_DIR.html) 
to generate the python binary package.  
We want this layout (`tree build --prune -U -P "*.py|*.so*" -I "build"`):
```shell
build/python
├── setup.py
└── CMakeSwig
    ├── __init__.py
    ├── Bar
    │   ├── __init__.py
    │   ├── _pyBar.so
    │   └── pyBar.py
    ├── FooBar
    │   ├── __init__.py
    │   ├── _pyFooBar.so
    │   └── pyFooBar.py
    ├── Foo
    │   ├── __init__.py
    │   ├── pyFoo.py
    │   └── _pyFoo.so
    └── .libs
        ├── libBar.so.1.0
        ├── libFooBar.so.1.0
        └── libFoo.so.1.0
```

## Build the Binary Package
To build the python package, simply run:
```sh
cmake --build build --target bdist
```

