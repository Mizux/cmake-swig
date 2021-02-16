#!/usr/bin/env python3
'''Test API'''

import unittest
import cmakeswig.Foo.pyFoo as foo
import cmakeswig.Bar.pyBar as bar
import cmakeswig.FooBar.pyFooBar as foobar

class TestFoo(unittest.TestCase):
    '''Test Foo'''
    def test_free_function(self):
        print(f'pyFoo: ${dir(foo)}')
        foo.fooHello(1)
        foo.fooHello(2147483647) # max int
        foo.fooHello(2147483647+1) # max int + 1

    def test_foo_method(self):
        f = foo.Foo()
        print(f'class Foo: ${dir(f)}')
        f.hello(1)
        f.hello(2147483647)
        f.hello(2147483647+1)

class TestBar(unittest.TestCase):
    '''Test Bar'''
    def test_free_function(self):
        print(f'pyBar: ${dir(bar)}')
        bar.barHello(1)
        bar.barHello(2147483647) # max int
        bar.barHello(2147483647+1) # max int + 1

    def test_bar_method(self):
        b = bar.Bar()
        print(f'class Bar: ${dir(b)}')
        b.hello(1)
        b.hello(2147483647)
        b.hello(2147483647+1)


class TestFooBar(unittest.TestCase):
    '''Test FooBar'''
    def test_free_function(self):
        print(f'pyFooBar: ${dir(foobar)}')
        foobar.foobarHello(1)
        foobar.foobarHello(2147483647) # max int
        foobar.foobarHello(2147483647+1) # max int + 1

    def test_foobar_method(self):
        fb = foobar.FooBar()
        print(f'class FooBar: ${dir(fb)}')
        fb.hello(1)
        fb.hello(2147483647)
        fb.hello(2147483647+1)

if __name__ == '__main__':
    unittest.main(verbosity=2)
