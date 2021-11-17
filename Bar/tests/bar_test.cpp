#include <catch2/catch_test_macros.hpp>
#include <iostream>
#include <numeric>
#include <string>

#include <bar/Bar.hpp>

namespace bar {

TEST_CASE("Bar free function", "[Bar]") {
  SECTION("Int Function") { REQUIRE_NOTHROW(freeFunction(42)); }
  SECTION("Int64_t Function") { REQUIRE_NOTHROW(freeFunction(int64_t{42})); }
}

TEST_CASE("String Vector usage", "[Bar]") {
  SECTION("Vector of String Output") {
    std::vector<std::string> result;
    REQUIRE_NOTHROW(result = stringVectorOutput(8));
    REQUIRE(result.size() == 8);
    for (const auto& it : result) {
      REQUIRE(it == std::to_string(8));
    }
  }
  SECTION("Vector of String Input by value") {
    std::vector<std::string> data{"1", "2", "3", "4", "5"};
    int                      size = 0;
    REQUIRE_NOTHROW(size = stringVectorInput(data));
    REQUIRE(size == 5);
  }
  SECTION("Vector of String Input by const ref") {
    std::vector<std::string> data{"1", "2", "3", "4", "5"};
    int                      size = 0;
    REQUIRE_NOTHROW(size = stringVectorRefInput(data));
    REQUIRE(size == 5);
  }
}

TEST_CASE("String Jagged Array usage", "[Bar]") {
  SECTION("Jagged Array of String Output") {
    std::vector<std::vector<std::string>> result;
    REQUIRE_NOTHROW(result = stringJaggedArrayOutput(8));
    REQUIRE(result.size() == 8);
    for (int i = 0; i < result.size(); ++i) {
      REQUIRE(i + 1 == result[i].size());
    }
    for (int i = 1; i <= result.size(); ++i) {
      const auto& inner = result[i - 1];
      for (const auto& it : inner) {
        REQUIRE(it == std::to_string(i));
      }
    }
  }
  SECTION("Jagged Array of String Input by value") {
    std::vector<std::vector<std::string>> data{{"1", "2", "3"}, {"4", "5"}};
    int                                   size = 0;
    REQUIRE_NOTHROW(size = stringJaggedArrayInput(data));
    REQUIRE(size == 2);
  }
  SECTION("Jagged Array of String Input by const ref") {
    std::vector<std::vector<std::string>> data{{"1", "2", "3"}, {"4", "5"}};
    int                                   size = 0;
    REQUIRE_NOTHROW(size = stringJaggedArrayRefInput(data));
    REQUIRE(size == 2);
  }
}

TEST_CASE("Pair Vector usage", "[Bar]") {
  SECTION("Vector of Pair Output") {
    std::vector<std::string> result;
    REQUIRE_NOTHROW(result = stringVectorOutput(8));
    REQUIRE(result.size() == 8);
    for (const auto& it : result) {
      REQUIRE(it == std::to_string(8));
    }
  }
  SECTION("Vector of Pair Input by value") {
    std::vector<std::string> data{"1", "2", "3", "4", "5"};
    int                      size = 0;
    REQUIRE_NOTHROW(size = stringVectorInput(data));
    REQUIRE(size == 5);
  }
  SECTION("Vector of Pair Input by const ref") {
    std::vector<std::string> data{"1", "2", "3", "4", "5"};
    int                      size = 0;
    REQUIRE_NOTHROW(size = stringVectorRefInput(data));
    REQUIRE(size == 5);
  }
}

TEST_CASE("Pair Jagged Array usage", "[Bar]") {
  SECTION("Jagged Array of Pair Output") {
    std::vector<std::vector<std::pair<int, int>>> result;
    REQUIRE_NOTHROW(result = pairJaggedArrayOutput(8));
    REQUIRE(result.size() == 8);
    for (int i = 0; i < result.size(); ++i) {
      REQUIRE(i + 1 == result[i].size());
    }
    for (int i = 1; i <= result.size(); ++i) {
      const auto& inner = result[i - 1];
      for (const auto& it : inner) {
        REQUIRE(it == std::make_pair(i, i));
      }
    }
  }
  SECTION("Jagged Array of Pair Input by value") {
    std::vector<std::vector<std::pair<int, int>>> data{{{1, 1}, {2, 2}, {3, 3}}, {{4, 4}, {5, 5}}};
    int                                           size = 0;
    REQUIRE_NOTHROW(size = pairJaggedArrayInput(data));
    REQUIRE(size == 2);
  }
  SECTION("Jagged Array of Pair Input by const ref") {
    std::vector<std::vector<std::pair<int, int>>> data{{{1, 1}, {2, 2}, {3, 3}}, {{4, 4}, {5, 5}}};
    int                                           size = 0;
    REQUIRE_NOTHROW(size = pairJaggedArrayRefInput(data));
    REQUIRE(size == 2);
  }
}

TEST_CASE("Bar static method", "[Bar]") {
  SECTION("Int Method") { REQUIRE_NOTHROW(Bar::staticFunction(42)); }
  SECTION("Int64_t Method") { REQUIRE_NOTHROW(Bar::staticFunction(int64_t{42})); }
}

TEST_CASE("Bar::Ctor", "[Bar]") {
  SECTION("Default constructor") {
    Bar* b = new Bar();
    REQUIRE(b != nullptr);
  }
}

SCENARIO("Bar Int", "[Bar]") {
  GIVEN("A Bar instance") {
    Bar bar;
    WHEN("Setting a value") {
      REQUIRE_NOTHROW(bar.setInt(42));
      THEN("The value is updated") { REQUIRE(bar.getInt() == 42); }
    }
  }
}

SCENARIO("Bar Int64", "[Bar]") {
  GIVEN("A Bar instance") {
    Bar bar;
    WHEN("Setting a value") {
      REQUIRE_NOTHROW(bar.setInt64(31));
      THEN("The value is updated") { REQUIRE(bar.getInt64() == 31); }
    }
  }
}

TEST_CASE("Bar::operator()", "[Bar]") {
  SECTION("Debug print") { INFO("Bar: " << Bar()()); }
}

} // namespace bar
