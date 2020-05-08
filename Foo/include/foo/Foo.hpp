#pragma once

#include <cstdint>
#include <string>

//! @namespace foo The Foo namespace
namespace foo {
/*! @brief Free function in foo namespace.
 * @param level Scope level.*/
void fooHello(int level);

/*! @brief Free function in foo namespace.
 * @param level Scope level.*/
void fooHello(int64_t level);

//! @brief Class Foo.
class Foo {
 public:
  /*! @defgroup StaticMembers Static members
	 * @{ */

  /*! @brief Static method of Foo class.
	 * @param level Scope level.*/
  static void hello(int level);

  /*! @brief Static method of Foo class.
   * @param level Scope level.*/
  static void hello(int64_t level);

  //! @}

  /*! @defgroup IntegerMembers Integer members
   * @{ */

  /*! @brief Method (getter) of Foo class.
   * @return A member value.*/
  int getInt() const;
  /*! @brief Method (setter) of Foo class.
   * @param input A member value.*/
  void setInt(int input);

  //! @}

  /*! @defgroup Int64Members Long Integer members
   * @{ */

  /*! @brief Method (getter) of Foo class.
   * @return A member value.*/
  int64_t getInt64() const;
  /*! @brief Method (setter) of Foo class.
   * @param input A member value.*/
  void setInt64(int64_t input);

  //! @}

  //! @brief Print object for debug.
  std::string operator()() const;

 private:
  int _intValue = 0;
  int64_t _int64Value = 0;
};
} // namespace foo
