%module csFooBar

%include "stdint.i"
%include "std_vector.i"
%include "std_string.i"
%include "std_pair.i"
%include "base.i"

%template(StringVector) std::vector<std::string>;
%template(StringJaggedArray) std::vector<std::vector<std::string>>;

%template(IntPair) std::pair<int, int>;
%template(PairVector) std::vector<std::pair<int, int>>;
%template(PairJaggedArray) std::vector<std::vector<std::pair<int, int>>>;

// Add necessary symbols to generated header
%{
#include <foobar/FooBar.hpp>
%}

%ignore ""; // ignore all
%define %unignore %rename("%s") %enddef

%unignore foobar;
namespace foobar {
%rename("StringVectorOutput") stringVectorOutput(int);
%rename("StringVectorInput") stringVectorInput(std::vector<std::string>);
%rename("StringVectorRefInput") stringVectorRefInput(const std::vector<std::string>&);

%unignore stringJaggedArrayOutput(int);
%unignore stringJaggedArrayInput(std::vector<std::vector<std::string>>);
%unignore stringJaggedArrayRefInput(const std::vector<std::vector<std::string>>&);

%rename("PairVectorOutput") pairVectorOutput(int);
%rename("PairVectorInput") pairVectorInput(std::vector<std::pair<int, int>>);
%rename("PairVectorRefInput") pairVectorRefInput(const std::vector<std::pair<int, int>>&);

%rename("PairJaggedArrayOutput") pairJaggedArrayOutput(int);
%rename("PairJaggedArrayInput") pairJaggedArrayInput(std::vector<std::vector<std::pair<int, int>>>);
%rename("PairJaggedArrayRefInput") pairJaggedArrayRefInput(const std::vector<std::vector<std::pair<int, int>>>&);

%rename("FreeFunction") freeFunction(int);
%rename("FreeFunction") freeFunction(int64_t);

%unignore FooBar;
%rename("StaticFunction") FooBar::staticFunction(int);
%rename("StaticFunction") FooBar::staticFunction(int64_t);

%rename("GetInt") FooBar::getInt() const;
%rename("SetBarInt") FooBar::setBarInt(int);
%rename("SetFooInt") FooBar::setFooInt(int);

%rename("GetInt64") FooBar::getInt64() const;
%rename("SetBarInt64") FooBar::setBarInt64(int64_t);
%rename("SetFooInt64") FooBar::setFooInt64(int64_t);

%rename ("ToString") FooBar::operator();
} // namespace foo

// Process symbols in header
%include "foobar/FooBar.hpp"

%unignore ""; // unignore all
