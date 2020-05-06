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

std::string Foo::operator()() const {
  return std::string{"\"Foo\":{\"int\":"} + std::to_string(_intValue) + ",\"int64\":" + std::to_string(_int64Value) +
         "}";
}

int Foo::getInt() const {
  return _intValue;
}

void Foo::setInt(int input) {
  _intValue = input;
}

int64_t Foo::getInt64() const {
  return _int64Value;
}

void Foo::setInt64(int64_t input) {
  _int64Value = input;
}

} // namespace foo
