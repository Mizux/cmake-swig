# CI: Makefile/Docker testing
To test the build, there is a Makefile in [ci](.) folder using
docker containers to test on various distro.

To get the help simply type:
```sh
make
```

note: you can also use from top directory
```sh
make --directory=ci
```

For example to test inside a container:
```sh
make test_devel
```
