%module csBar

%include "std_string.i"
%include "base.i"

// Add necessary symbols to generated header
%{
#include <bar/Bar.hpp>
%}

// Process symbols in header
%include "bar/Bar.hpp"
