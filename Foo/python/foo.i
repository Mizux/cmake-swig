%module pyFoo

%include "stdint.i"
%include "std_vector.i"
%include "std_string.i"
%include "std_pair.i"

%template(StringVector) std::vector<std::string>;
%template(StringJaggedArray) std::vector<std::vector<std::string>>;

%template(IntPair) std::pair<int, int>;
%template(PairVector) std::vector<std::pair<int, int>>;
%template(PairJaggedArray) std::vector<std::vector<std::pair<int, int>>>;

// Add necessary symbols to generated header
%{
#include <foo/Foo.hpp>
%}

%ignore ""; // ignore all
%define %unignore %rename("%s") %enddef

%unignore foo;
namespace foo {
%rename("string_vector_output") stringVectorOutput(int);
%rename("string_vector_input") stringVectorInput(std::vector<std::string>);
%rename("string_vector_ref_input") stringVectorRefInput(const std::vector<std::string>&);

%rename("string_jagged_array_output") stringJaggedArrayOutput(int);
%rename("string_jagged_array_input") stringJaggedArrayInput(std::vector<std::vector<std::string>>);
%rename("string_jagged_array_ref_input") stringJaggedArrayRefInput(const std::vector<std::vector<std::string>>&);

%rename("pair_vector_output") pairVectorOutput(int);
%rename("pair_vector_input") pairVectorInput(std::vector<std::pair<int, int>>);
%rename("pair_vector_ref_input") pairVectorRefInput(const std::vector<std::pair<int, int>>&);

%rename("pair_jagged_array_output") pairJaggedArrayOutput(int);
%rename("pair_jagged_array_input") pairJaggedArrayInput(std::vector<std::vector<std::pair<int, int>>>);
%rename("pair_jagged_array_ref_input") pairJaggedArrayRefInput(const std::vector<std::vector<std::pair<int, int>>>&);

%rename("free_function") freeFunction(int);
%rename("free_function") freeFunction(int64_t);

%unignore Foo;
%rename ("static_function") Foo::staticFunction(int);
%rename ("static_function") Foo::staticFunction(int64_t);

%rename ("get_int") Foo::getInt() const;
%rename ("set_int") Foo::setInt(int);

%rename ("get_int64") Foo::getInt64() const;
%rename ("set_int64") Foo::setInt64(int64_t);

%rename ("__str__") Foo::operator();
} // namespace foo

// Process symbols in header
%include "foo/Foo.hpp"

%unignore ""; // unignore all
