#include "bar/Bar.hpp"

#include <iostream>

namespace bar {
void barHello(int level) {
  std::cout << "[" << level << "] Enter barHello(int)" << std::endl;
  std::cout << "[" << level << "] Exit barHello(int)" << std::endl;
}

void barHello(int64_t level) {
  std::cout << "[" << level << "] Enter barHello(int64_t)" << std::endl;
  std::cout << "[" << level << "] Exit barHello(int64_t)" << std::endl;
}

void Bar::hello(int level) {
  std::cout << "[" << level << "] Enter Bar::hello(int)" << std::endl;
  bar::barHello(level + 1);
  std::cout << "[" << level << "] Exit Bar::hello(int)" << std::endl;
}

void Bar::hello(int64_t level) {
  std::cout << "[" << level << "] Enter Bar::hello(int64_t)" << std::endl;
  bar::barHello(level + 1);
  std::cout << "[" << level << "] Exit Bar::hello(int64_t)" << std::endl;
}

std::string Bar::operator()() const {
  return std::string{"\"Bar\":{\"int\":"} + std::to_string(_intValue) +
         ",\"int64\":" + std::to_string(_int64Value) + "}";
}

int Bar::getInt() const {
  return _intValue;
}

void Bar::setInt(int input) {
  _intValue = input;
}

int64_t Bar::getInt64() const {
  return _int64Value;
}

void Bar::setInt64(int64_t input) {
  _int64Value = input;
}

} // namespace bar
