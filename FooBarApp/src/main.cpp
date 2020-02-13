#include <cstdint>
#include <iostream>
#include <foobar/FooBar.hpp>

int main(int argc, char** argv) {
  foobar::FooBar::hello((int)1);
  std::cout << std::endl;
  foobar::FooBar::hello((int64_t)1);

  return 0;
}
