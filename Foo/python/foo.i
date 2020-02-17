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
%rename ("toString") foo::Foo::operator();

// Process symbols in header
%include "foo/Foo.hpp"

%rename("%s") ""; // unignore all
