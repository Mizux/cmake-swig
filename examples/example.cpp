#include <iostream>

#include <foo/Foo.hpp>
#include <bar/Bar.hpp>
#include <foobar/FooBar.hpp>

int main(int /*argc*/, char** /*argv*/) {
  foo::fooHello(0);
  bar::barHello(0);
  foobar::foobarHello(1);
  std::cout << std::endl;
  foobar::FooBar::hello(int{1});
  std::cout << std::endl;

  return 0;
}
