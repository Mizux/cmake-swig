%module csFoo

%include "std_string.i"
%include "base.i"

// Add necessary symbols to generated header
%{
#include <foo/Foo.hpp>
%}

// Process symbols in header
%include "foo/Foo.hpp"
