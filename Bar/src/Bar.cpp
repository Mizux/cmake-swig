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

std::string Bar::operator()() const { return "Bar"; }
}  // namespace bar
