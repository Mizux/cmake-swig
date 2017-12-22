#pragma once

#include <string>

namespace foo {
  void fooHello();

	class Foo {
		public:
			std::string operator()() const;
	};
}

