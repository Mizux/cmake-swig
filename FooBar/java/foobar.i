%module main

%include "std_string.i"
%include "base.i"

// Add necessary symbols to generated header
%{
#include <foobar/FooBar.hpp>
%}

%ignore "";
%define %unignore %rename("%s") %enddef

%unignore foobar;
namespace foobar {
%unignore foobarHello(int);
%unignore foobarHello(int64_t);

%unignore FooBar;
%unignore FooBar::hello(int);
%unignore FooBar::hello(int64_t);

%unignore FooBar::getInt() const;
%unignore FooBar::setBarInt(int);
%unignore FooBar::setFooInt(int);

%unignore FooBar::getInt64() const;
%unignore FooBar::setBarInt64(int64_t);
%unignore FooBar::setFooInt64(int64_t);

%rename ("toString") FooBar::operator();
} // namespace foobar

// Process symbols in header
%include "foobar/FooBar.hpp"

%unignore ""; // unignore all
