%module main

%include "std_string.i"
%include "base.i"

// Add necessary symbols to generated header
%{
#include <bar/Bar.hpp>
%}

%ignore "";
%define %unignore %rename("%s") %enddef

%unignore bar;
namespace bar {
%unignore barHello(int);
%unignore barHello(int64_t);

%unignore Bar;
%unignore Bar::hello(int);
%unignore Bar::hello(int64_t);

%unignore Bar::getInt() const;
%unignore Bar::setInt(int);

%unignore Bar::getInt64() const;
%unignore Bar::setInt64(int64_t);

%rename ("toString") Bar::operator();
} // namespace bar

// Process symbols in header
%include "bar/Bar.hpp"

%unignore ""; // unignore all
