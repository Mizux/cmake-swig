#pragma once

#include <cstdint>
#include <string>

//! @namespace bar The Bar namespace
namespace bar {
//! @brief Free function in bar namespace.
//! @param[in] level Scope level.
void barHello(int level);

//! @brief Free function in bar namespace.
//! @param[in] level Scope level.
void barHello(int64_t level);

//! @brief Class Bar.
class Bar {
 public:
  //! @brief Static method of Bar class.
  //! @param[in] level Scope level.
  static void hello(int level);

  //! @brief Static method of Bar class.
  //! @param[in] level Scope level.
  static void hello(int64_t level);

  std::string operator()() const;
};
}  // namespace bar
