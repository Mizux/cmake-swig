#include "foo/Foo.hpp"

#include <iostream>

namespace foo {
void fooHello(int level) {
  std::cout << "[" << level << "] Enter fooHello" << std::endl;
  std::cout << "[" << level << "] Exit fooHello" << std::endl;
}

void Foo::hello(int level) {
  std::cout << "[" << level << "] Enter Foo::hello" << std::endl;
  foo::fooHello(level + 1);
  std::cout << "[" << level << "] Exit Foo::hello" << std::endl;
}

std::string Foo::operator()() const { return "Foo"; }
}  // namespace foo
