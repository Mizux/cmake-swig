%module main

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
%unignore fooHello(int);
%unignore fooHello(int64_t);

%unignore Foo;
%unignore Foo::hello(int);
%unignore Foo::hello(int64_t);

%unignore Foo::getInt() const;
%unignore Foo::setInt(int);

%unignore Foo::getInt64() const;
%unignore Foo::setInt64(int64_t);

%rename ("toString") Foo::operator();
} // namespace foo

// Process symbols in header
%include "foo/Foo.hpp"

%unignore ""; // unignore all
