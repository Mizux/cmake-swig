#pragma once

//! @namespace foobar The Foobar namespace.
namespace foobar {
//! @brief Free function in foobar namespace
//! @param[in] level Scope level.
void foobarHello(int level);

//! @brief Class FooBar.
class FooBar {
 public:
  //! @brief Static method of FooBar class.
  //! @param[in] level Scope level.
  static void hello(int level);

  void operator()() const;
};
}  // namespace foobar
