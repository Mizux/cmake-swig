%module csFoo

%include "std_string.i"
%include "base.i"

// Add necessary symbols to generated header
%{
#include <foo/Foo.hpp>
%}

%ignore "";
%define %unignore %rename("%s") %enddef

%unignore foo;
namespace foo {
%rename("FooHello") fooHello(int);
%rename("FooHello") fooHello(int64_t);

%unignore Foo;
%rename("Hello") Foo::hello(int);
%rename("Hello") Foo::hello(int64_t);

%rename("GetInt") Foo::getInt() const;
%rename("SetInt") Foo::setInt(int);

%rename("GetInt64") Foo::getInt64() const;
%rename("SetInt64") Foo::setInt64(int64_t);

%rename ("ToString") Foo::operator();
} // namespace foo

// Process symbols in header
%include "foo/Foo.hpp"

%unignore ""; // unignore all
