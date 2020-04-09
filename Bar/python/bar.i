%module pyBar

%include "stdint.i"
%include "std_string.i"
// Add necessary symbols to generated header
%{
#include <bar/Bar.hpp>
%}

%ignore ""; // ignore all
%define %unignore %rename("%s") %enddef

%unignore bar;
%unignore bar::barHello(int);
%unignore bar::barHello(int64_t);

%unignore bar::Bar;
%unignore bar::Bar::hello(int);
%unignore bar::Bar::hello(int64_t);

%rename ("get_int") bar::Bar::getInt() const;
%rename ("set_int") bar::Bar::setInt(int);

%rename ("get_int64") bar::Bar::getInt64() const;
%rename ("set_int64") bar::Bar::setInt64(int64_t);

%rename ("__str__") bar::Bar::operator();

// Process symbols in header
%include "bar/Bar.hpp"

%unignore ""; // unignore all
