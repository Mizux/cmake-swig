#include <foobar/FooBar.hpp>

#include <iostream>
#include <foo/Foo.hpp>
#include <bar/Bar.hpp>

namespace foobar {
  void fooBarHello() {
    std::cout << "fooBarHello" << std::endl;
  }

void FooBar::operator()() const {
	foo::Foo foo;
	bar::Bar bar;
	std::cout << foo() << bar() << std::endl;
}
}

