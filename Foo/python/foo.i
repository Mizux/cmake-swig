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
%unignore foo::fooHello(int);
%unignore foo::fooHello(int64_t);

%unignore foo::Foo;
%unignore foo::Foo::hello(int);
%unignore foo::Foo::hello(int64_t);

%rename ("get_int") foo::Foo::getInt();
%rename ("set_int") foo::Foo::setInt(int);

%rename ("get_int64") foo::Foo::getInt64();
%rename ("set_int64") foo::Foo::setInt64(int64_t);

%rename ("__str__") foo::Foo::operator();

// Process symbols in header
%include "foo/Foo.hpp"

%unignore ""; // unignore all
