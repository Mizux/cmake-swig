# Python Wrapper
## Build directory layout
Since we want to use the [CMAKE_BINARY_DIR](https://cmake.org/cmake/help/latest/variable/CMAKE_BINARY_DIR.html) 
to generate the python binary package.  
We want this layout (`tree build --prune -P "*.py|*.so"`):
```shell
 Bar
 ├── __init__.py
 ├── libBar.so
 ├── pyBar.py
 └── _pyBar.so
 Foo
 ├── __init__.py
 ├── libFoo.so
 ├── pyFoo.py
 └── _pyFoo.so
 FooBar
 ├── __init__.py
 ├── libFooBar.so
 ├── pyFooBar.py
 └── _pyFooBar.so
```

## Build the Binary Package
To build the python package, simply run:
```sh
make bdist
```

