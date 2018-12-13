#include "bar/Bar.hpp"

#include <iostream>

namespace bar {
void barHello(int level) {
  std::cout << "[" << level << "] Enter barHello" << std::endl;
  std::cout << "[" << level << "] Exit barHello" << std::endl;
}

void Bar::hello(int level) {
  std::cout << "[" << level << "] Enter Bar::hello" << std::endl;
  bar::barHello(level + 1);
  std::cout << "[" << level << "] Exit Bar::hello" << std::endl;
}

std::string Bar::operator()() const { return "Bar"; }
}  // namespace bar
