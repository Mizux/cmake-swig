#pragma once

#include <string>

namespace bar {
  void barHello();

	class Bar {
		public:
			std::string operator()() const;
	};
}

