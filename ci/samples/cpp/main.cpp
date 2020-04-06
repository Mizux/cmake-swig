#include <iostream>
#include <foobar/FooBar.hpp>

int main(int /*argc*/, char** /*argv*/) {
  foobar::foobarHello(1);
	std::cout << std::endl;
	foobar::FooBar::hello(int{1});
	std::cout << std::endl;

	return 0;
}

