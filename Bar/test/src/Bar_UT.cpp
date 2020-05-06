#include <bar/Bar.hpp>
#include <catch2/catch.hpp>
#include <iostream>
#include <numeric>

namespace bar {

TEST_CASE("Bar free function", "[Bar]") {
  SECTION("Int Function") { REQUIRE_NOTHROW(barHello(42)); }
  SECTION("Int64_t Function") { REQUIRE_NOTHROW(barHello(int64_t{42})); }
}

TEST_CASE("Bar static method", "[Bar]") {
  SECTION("Int Method") { REQUIRE_NOTHROW(Bar::hello(42)); }
  SECTION("Int64_t Method") { REQUIRE_NOTHROW(Bar::hello(int64_t{42})); }
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
