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
	//! @defgroup StaticMembers Static members
	//! @{

	//! @brief Static method of Bar class.
	//! @param[in] level Scope level.
	static void hello(int level);

	//! @brief Static method of Bar class.
	//! @param[in] level Scope level.
	static void hello(int64_t level);

	//! @}

	//! @defgroup IntegerMembers Integer members
	//! @{

	//! @brief Method (getter) of Bar class.
	//! @return A member value.
	int getInt() const;
	//! @brief Method (setter) of Bar class.
	//! @param[in] input A member value.
	void setInt(int input);

	//! @}

	//! @defgroup Int64Members Long Integer members
	//! @{

	//! @brief Method (getter) of Bar class.
	//! @return A member value.
	int64_t getInt64() const;
	//! @brief Method (setter) of Bar class.
	//! @param[in] input A member value.
	void setInt64(int64_t input);

	//! @}

	//! @brief Print object for debug.
	std::string operator()() const;

	private:
	int _intValue       = 0;
	int64_t _int64Value = 0;
};
} // namespace bar
