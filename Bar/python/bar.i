%module pyBar

%include "stdint.i"
%include "std_string.i"
// Add necessary symbols to generated header
%{
#include <bar/Bar.hpp>
%}

// Process symbols in header
%include "bar/Bar.hpp"
