#include <bar/Bar.hpp>

#include <iostream>

namespace bar {
  void barHello() {
    std::cout << "barHello" << std::endl;
  }

	std::string Bar::operator()() const {
	return "Bar";
}
}

