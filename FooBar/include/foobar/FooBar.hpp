#pragma once

#include <bar/Bar.hpp>
#include <cstdint>
#include <foo/Foo.hpp>
#include <string>

//! @namespace foobar The Foobar namespace.
namespace foobar {
/*! @brief Free function in foobar namespace
 * @param level Scope level.*/
void foobarHello(int level);

/*! @brief Free function in foobar namespace
 * @param level Scope level.*/
void foobarHello(int64_t level);

//! @brief Class FooBar.
class FooBar {
 public:
  /*! @defgroup StaticMembers Static members
   * @{ */

  /*! @brief Static method of FooBar class.
   * @param level Scope level.*/
  static void hello(int level);

  /*! @brief Static method of FooBar class.
   * @param level Scope level.*/
  static void hello(int64_t level);

  //! @}

  /*! @defgroup IntegerMembers Integer members
   * @{ */

  /*! @brief Get sum of internal members.
   * @return The sum of Bar and Foo.*/
  int getInt() const;
  /*! @brief Set value of internal Bar class.
   * @param input A member value.*/
  void setBarInt(int input);
  /*! @brief Set value of internal Foo class.
   * @param input A member value.*/
  void setFooInt(int input);

  //! @}

  /*! @defgroup Int64Members Long Integer members
   * @{ */

  /*! @brief Get sum of internal members.
   * @return The sum of Bar and Foo.*/
  int64_t getInt64() const;
  /*! @brief Set value of internal Bar class.
   * @param input A member value.*/
  void setBarInt64(int64_t input);
  /*! @brief Set value of internal Foo class.
   * @param input A member value.*/
  void setFooInt64(int64_t input);

  //! @}

  //! @brief Print object for debug.
  std::string operator()() const;

 private:
  bar::Bar _bar;
  foo::Foo _foo;
};
} // namespace foobar
