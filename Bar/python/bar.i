%module pyBar

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
#include <bar/Bar.hpp>
%}

%ignore ""; // ignore all
%define %unignore %rename("%s") %enddef

%unignore bar;
namespace bar {
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

%unignore Bar;
%rename ("static_function") Bar::staticFunction(int);
%rename ("static_function") Bar::staticFunction(int64_t);

%rename ("get_int") Bar::getInt() const;
%rename ("set_int") Bar::setInt(int);

%rename ("get_int64") Bar::getInt64() const;
%rename ("set_int64") Bar::setInt64(int64_t);

%rename ("__str__") Bar::operator();
} // namespace bar

// Process symbols in header
%include "bar/Bar.hpp"

%unignore ""; // unignore all
