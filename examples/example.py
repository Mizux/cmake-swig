from pythonnative.foo.pyFoo import *

print(f'Foo: ${dir(Foo)}')

p = IntPair(3, 5)
print(f"class IntPair: {dir(p)}")
print(f"p: {p}")

free_function(2147483647) # max int
free_function(2147483647+1) # max int + 1

f = Foo()
print(f'class Foo: ${dir(f)}')
f.static_function(1)
f.static_function(2147483647)
f.static_function(2147483647+1)

f.set_int(13)
assert(f.get_int() == 13)

f.set_int64(31)
assert(f.get_int64() == 31)
