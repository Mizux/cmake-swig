import cmakeswig
from cmakeswig.foo import pyFoo
from cmakeswig.bar import pyBar
from cmakeswig.foobar import pyFooBar

print(f'version: {cmakeswig.__version__}')

# foo
print(f'Foo: {dir(pyFoo.Foo)}')

p = pyFoo.IntPair(3, 5)
print(f"class IntPair: {dir(p)}")
print(f"p: {p}")
pyFoo.free_function(2147483647) # max int
pyFoo.free_function(2147483647+1) # max int + 1

f = pyFoo.Foo()
print(f'class Foo: {dir(f)}')
f.static_function(1)
f.static_function(2147483647)
f.static_function(2147483647+1)
f.set_int(13)
assert(f.get_int() == 13)
f.set_int64(31)
assert(f.get_int64() == 31)

# bar
print(f'Bar: {dir(pyBar.Bar)}')

p = pyBar.IntPair(3, 5)
print(f"class IntPair: {dir(p)}")
print(f"p: {p}")
pyBar.free_function(2147483647) # max int
pyBar.free_function(2147483647+1) # max int + 1

b = pyBar.Bar()
print(f'class Bar: {dir(b)}')
b.static_function(1)
b.static_function(2147483647)
b.static_function(2147483647+1)
b.set_int(13)
assert(b.get_int() == 13)
b.set_int64(31)
assert(b.get_int64() == 31)

# foobar
print(f'FooBar: {dir(pyFooBar.FooBar)}')

p = pyFooBar.IntPair(3, 5)
print(f"class IntPair: {dir(p)}")
print(f"p: {p}")
pyFooBar.free_function(2147483647) # max int
pyFooBar.free_function(2147483647+1) # max int + 1

fb = pyFooBar.FooBar()
print(f'class FooBar: {dir(fb)}')
fb.static_function(1)
fb.static_function(2147483647)
fb.static_function(2147483647+1)
fb.set_foo_int(13)
fb.set_bar_int(17)
assert(fb.get_int() == 30)
fb.set_foo_int64(31)
fb.set_bar_int64(37)
assert(fb.get_int64() == 68)
