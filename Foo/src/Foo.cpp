#include "foo/Foo.hpp"

#include <iostream>

namespace foo {
void fooHello(int level) {
  std::cout << "[" << level << "] Enter fooHello(int)" << std::endl;
  std::cout << "[" << level << "] Exit fooHello(int)" << std::endl;
}

void fooHello(int64_t level) {
  std::cout << "[" << level << "] Enter fooHello(int64_t)" << std::endl;
  std::cout << "[" << level << "] Exit fooHello(int64_t)" << std::endl;
}

void Foo::hello(int level) {
  std::cout << "[" << level << "] Enter Foo::hello(int)" << std::endl;
  foo::fooHello(level + 1);
  std::cout << "[" << level << "] Exit Foo::hello(int)" << std::endl;
}

void Foo::hello(int64_t level) {
  std::cout << "[" << level << "] Enter Foo::hello(int64_t)" << std::endl;
  foo::fooHello(level + 1);
  std::cout << "[" << level << "] Exit Foo::hello(int64_t)" << std::endl;
}

std::string Foo::operator()() const { return "Foo"; }
}  // namespace foo
