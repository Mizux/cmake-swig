#include "foobar/FooBar.hpp"

#include <iostream>

#include "bar/Bar.hpp"
#include "foo/Foo.hpp"

namespace foobar {
void foobarHello(int level) {
  std::cout << "[" << level << "] Enter foobarHello(int)" << std::endl;
  std::cout << "[" << level << "] Exit foobarHello(int)" << std::endl;
}

void foobarHello(int64_t level) {
  std::cout << "[" << level << "] Enter foobarHello(int64_t)" << std::endl;
  std::cout << "[" << level << "] Exit foobarHello(int64_t)" << std::endl;
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

int FooBar::getInt() const {
  return _bar.getInt() + _foo.getInt();
}

void FooBar::setBarInt(int input) {
  _bar.setInt(input);
}

void FooBar::setFooInt(int input) {
  _foo.setInt(input);
}

int64_t FooBar::getInt64() const {
  return _bar.getInt64() + _foo.getInt64();
}

void FooBar::setBarInt64(int64_t input) {
  _bar.setInt64(input);
}

void FooBar::setFooInt64(int64_t input) {
  _foo.setInt64(input);
}

std::string FooBar::operator()() const {
  return std::string{"\"FooBar\":{"} + _bar() + "," + _foo() + "}";
}

} // namespace foobar
