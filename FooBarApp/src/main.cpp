#include <cstdint>
#include <foobar/FooBar.hpp>
#include <iostream>
#include <string>

int main(int /*argc*/, char** /*argv*/) {
  foobar::freeFunction(int{0});
  std::cout << std::endl;
  foobar::freeFunction(int64_t{1});
  std::cout << std::endl;

  foobar::FooBar::staticFunction(int{2});
  std::cout << std::endl;
  foobar::FooBar::staticFunction(int64_t{3});
  std::cout << std::endl;

  foobar::FooBar f;
  f.setBarInt(13);
  f.setFooInt(17);
  std::cout << std::to_string(f.getInt()) << std::endl;

  f.setBarInt64(int64_t{31});
  f.setFooInt64(int64_t{42});
  std::cout << std::to_string(f.getInt64()) << std::endl;

  std::cout << f() << std::endl;

  return 0;
}
