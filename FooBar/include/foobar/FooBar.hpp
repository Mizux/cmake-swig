#pragma once

#include <cstdint>
#include <string>
#include <vector>
#include <bar/Bar.hpp>
#include <foo/Foo.hpp>

//! @namespace foobar The FooBar namespace
namespace foobar {
//! @defgroup StringVector Vector of String usage.
//! @{
/*! @brief Test returning a vector of string.
 * @param level Scope level.
 * @return A vector of string.*/
std::vector<std::string> stringVectorOutput(int level);
/*! @brief Test using a vector of string passed by value.
 * @param data Input data.
 * @return The size of the data vector.*/
int stringVectorInput(std::vector<std::string> data);
/*! @brief Test using a vector of string passed by const ref.
 * @param data Input data.
 * @return The size of the data vector.*/
int stringVectorRefInput(const std::vector<std::string>& data);
//! @}

//! @defgroup StringJaggedArray Vector of Vector of String usage.
//! @{
/*! @brief Test returning a jagged array of string.
 * @param level Scope level.
 * @return A jagged array of string.*/
std::vector<std::vector<std::string>> stringJaggedArrayOutput(int level);
/*! @brief Test using a jagged array of string passed by value.
 * @param data Input data.
 * @return The size of the data outer vector.*/
int stringJaggedArrayInput(std::vector<std::vector<std::string>> data);
/*! @brief Test using a jagged array of string passed by const ref.
 * @param data Input data.
 * @return The size of the data outer vector.*/
int stringJaggedArrayRefInput(const std::vector<std::vector<std::string>>& data);
//! @}

//! @defgroup PairVector Vector of Pair usage.
//! @{
/*! @brief Test returning a vector of pair.
 * @param level Scope level.
 * @return A vector of pair.*/
std::vector<std::pair<int, int>> pairVectorOutput(int level);
/*! @brief Test using a vector of pair passed by value.
 * @param data Input data.
 * @return The size of the data vector.*/
int pairVectorInput(std::vector<std::pair<int, int>> data);
/*! @brief Test using a vector of pair passed by const ref.
 * @param data Input data.
 * @return The size of the data vector.*/
int pairVectorRefInput(const std::vector<std::pair<int, int>>& data);
//! @}

//! @defgroup PairJaggedArray Jagged array of Pair<int, int> usage.
//! @{
/*! @brief Test returning a jagged array of pair.
 * @param level Scope level.
 * @return A jagged array of pair.*/
std::vector<std::vector<std::pair<int, int>>> pairJaggedArrayOutput(int level);
/*! @brief Test using a jagged array of pair passed by value.
 * @param data Input data.
 * @return The size of the data outer vector.*/
int pairJaggedArrayInput(std::vector<std::vector<std::pair<int, int>>> data);
/*! @brief Test using a jagged of pair passed by const ref.
 * @param data Input data.
 * @return The size of the data outer vector.*/
int pairJaggedArrayRefInput(const std::vector<std::vector<std::pair<int, int>>>& data);
//! @}

//! @defgroup FreeFunction Free function usage.
//! @{
/*! @brief Free function in foobar namespace.
 * @param level Scope level.*/
void freeFunction(int level);
/*! @brief Free function in foobar namespace.
 * @param level Scope level.*/
void freeFunction(int64_t level);
//! @}

//! @brief Class FooBar.
class FooBar {
 public:
  //! @defgroup StaticMembers Static members
  //! @{

  /*! @brief Static method of FooBar class.
   * @param[in] level Scope level.*/
  static void staticFunction(int level);

  /*! @brief Static method of FooBar class.
   * @param[in] level Scope level.*/
  static void staticFunction(int64_t level);

  //! @}

  //! @defgroup IntegerMembers Integer members
  //! @{

  /*! @brief Method (getter) of FooBar class.
   * @return A member value.*/
  int getInt() const;
  /*! @brief Method (setter) of Bar nested class.
   * @param[in] input A member value.*/
  void setBarInt(int input);
  /*! @brief Method (setter) of Foo nested class.
   * @param[in] input A member value.*/
  void setFooInt(int input);

  //! @}

  //! @defgroup Int64Members Long Integer members
  //! @{

  /*! @brief Method (getter) of FooBar class.
   * @return A member value.*/
  int64_t getInt64() const;
  /*! @brief Set value of internal Bar nested class.
   * @param[in] input A member value.*/
  void setBarInt64(int64_t input);
  /*! @brief Set value of internal Foo nested class.
   * @param[in] input A member value.*/
  void setFooInt64(int64_t input);

  //! @}

  //! @brief Print object for debug.
  std::string operator()() const;

 private:
  bar::Bar _bar;
  foo::Foo _foo;
};
} // namespace foobar
