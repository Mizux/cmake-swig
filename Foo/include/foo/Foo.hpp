#pragma once

#include <cstdint>
#include <string>

//! @namespace foo The Foo namespace
namespace foo {
//! @brief Free function in foo namespace.
//! @param[in] level Scope level.
void fooHello(int level);

//! @brief Free function in foo namespace.
//! @param[in] level Scope level.
void fooHello(int64_t level);

//! @brief Class Foo.
class Foo {
 public:
  //! @brief Static method of Foo class.
  //! @param[in] level Scope level.
  static void hello(int level);

  //! @brief Static method of Foo class.
  //! @param[in] level Scope level.
  static void hello(int64_t level);

  std::string operator()() const;
};
}  // namespace foo
