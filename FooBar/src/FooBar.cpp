#include "foobar/FooBar.hpp"

#include <iostream>
#include "bar/Bar.hpp"
#include "foo/Foo.hpp"

namespace foobar {
void foobarHello(int level) {
  std::cout << "[" << level << "] Enter foobarHello" << std::endl;
  std::cout << "[" << level << "] Exit foobarHello" << std::endl;
}

void FooBar::hello(int level) {
  std::cout << "[" << level << "] Enter FooBar::hello(int)" << std::endl;
  foo::Foo::hello(level + 1);
  bar::Bar::hello(level + 1);
  std::cout << "[" << level << "] Exit FooBar::hello(int)" << std::endl;
}

void FooBar::hello(int64_t level) {
  std::cout << "[" << level << "] Enter FooBar::hello(int64_t)" << std::endl;
  foo::Foo::hello(level + 1);
  bar::Bar::hello(level + 1);
  std::cout << "[" << level << "] Exit FooBar::hello(int64_t)" << std::endl;
}

void FooBar::operator()() const {
  foo::Foo foo;
  bar::Bar bar;
  std::cout << foo() << bar() << std::endl;
}
}  // namespace foobar
