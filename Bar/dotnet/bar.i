%module csBar

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
%rename("BarHello") barHello(int);
%rename("BarHello") barHello(int64_t);

%unignore Bar;
%rename("Hello") Bar::hello(int);
%rename("Hello") Bar::hello(int64_t);

%rename("GetInt") Bar::getInt() const;
%rename("SetInt") Bar::setInt(int);

%rename("GetInt64") Bar::getInt64() const;
%rename("SetInt64") Bar::setInt64(int64_t);

%rename ("ToString") Bar::operator();
} // namespace bar

// Process symbols in header
%include "bar/Bar.hpp"

%unignore ""; // unignore all
