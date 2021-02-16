%module pyFoo

%include "stdint.i"
%include "std_string.i"
// Add necessary symbols to generated header
%{
#include <foo/Foo.hpp>
%}

%ignore ""; // ignore all
%define %unignore %rename("%s") %enddef

%unignore foo;
namespace foo {
%unignore fooHello(int);
%unignore fooHello(int64_t);

%unignore Foo;
%unignore Foo::hello(int);
%unignore Foo::hello(int64_t);

%rename ("get_int") Foo::getInt() const;
%rename ("set_int") Foo::setInt(int);

%rename ("get_int64") Foo::getInt64() const;
%rename ("set_int64") Foo::setInt64(int64_t);

%rename ("__str__") Foo::operator();
} // namespace foo

// Process symbols in header
%include "foo/Foo.hpp"

%unignore ""; // unignore all
