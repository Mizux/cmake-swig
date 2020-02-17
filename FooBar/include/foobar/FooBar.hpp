#pragma once

#include <cstdint>

//! @namespace foobar The Foobar namespace.
namespace foobar {
//! @brief Free function in foobar namespace
//! @param[in] level Scope level.
void foobarHello(int level);

//! @brief Free function in foobar namespace
//! @param[in] level Scope level.
void foobarHello(int64_t level);

//! @brief Class FooBar.
class FooBar {
 public:
  //! @brief Static method of FooBar class.
  //! @param[in] level Scope level.
  static void hello(int level);

  //! @brief Static method of FooBar class.
  //! @param[in] level Scope level.
  static void hello(int64_t level);

  void operator()() const;
};
}  // namespace foobar
