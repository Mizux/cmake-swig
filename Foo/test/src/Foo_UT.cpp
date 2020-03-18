#include <catch2/catch.hpp>

#include <foo/Foo.hpp>
#include <iostream>
#include <numeric>

namespace foo {

TEST_CASE("Foo free function", "[Foo]") {
	SECTION("Int Function") { REQUIRE_NOTHROW(fooHello(42)); }
	SECTION("Int64_t Function") { REQUIRE_NOTHROW(fooHello(int64_t{42})); }
}

TEST_CASE("Foo static method", "[Foo]") {
	SECTION("Int Method") { REQUIRE_NOTHROW(Foo::hello(42)); }
	SECTION("Int64_t Method") { REQUIRE_NOTHROW(Foo::hello(int64_t{42})); }
}

TEST_CASE("Foo::Ctor", "[Foo]") {
	SECTION("Default constructor") {
		Foo* b = new Foo();
		REQUIRE(b != nullptr);
	}
}

SCENARIO("Foo Int", "[Foo]") {
	GIVEN("A Foo instance") {
		Foo foo;
		WHEN("Setting a value") {
			REQUIRE_NOTHROW(foo.setInt(42));
			THEN("The value is updated") { REQUIRE(foo.getInt() == 42); }
		}
	}
}

SCENARIO("Foo Int64", "[Foo]") {
	GIVEN("A Foo instance") {
		Foo foo;
		WHEN("Setting a value") {
			REQUIRE_NOTHROW(foo.setInt64(31));
			THEN("The value is updated") { REQUIRE(foo.getInt64() == 31); }
		}
	}
}

TEST_CASE("Foo::operator()", "[Foo]") {
	SECTION("Debug print") { INFO("Foo: " << Foo()()); }
}

} // namespace foo
