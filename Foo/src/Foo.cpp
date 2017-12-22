#include <foo/Foo.hpp>

#include <iostream>

namespace foo {
  void fooHello() {
    std::cout << "fooHello" << std::endl;
  }

	std::string Foo::operator()() const {
	return "Foo";
}
}

