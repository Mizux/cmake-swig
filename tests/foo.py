#!/usr/bin/env python3
'''Test APIs'''

import unittest
import cmakeswig
from cmakeswig.foo import pyFoo
#import cmakeswig.foo.pyFoo as foo

if __debug__:
    print(f'version: {cmakeswig.__version__}')
    print(f'cmakeswig: ${dir(cmakeswig)}')
    print(f'cmakeswig.foo: ${dir(cmakeswig.foo)}')
    print(f'pyFoo: ${dir(pyFoo)}')


class TestpyFoo(unittest.TestCase):
    '''Test pyFoo'''
    def test_free_function(self):
        pyFoo.free_function(2147483647) # max int
        pyFoo.free_function(2147483647+1) # max int + 1

    def test_string_vector(self):
        v = pyFoo.string_vector_output(3)
        self.assertEqual(3, len(v))

    def test_string_jagged_array(self):
        v = pyFoo.string_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i+1, len(v[i]))
        self.assertEqual(
                3,
                pyFoo.string_jagged_array_input([['1'],['2','3'],['4','5','6']]))

    def test_int_pair(self):
        p = pyFoo.IntPair(3, 5)
        if __debug__:
            print(f"class IntPair: {dir(p)}")
        self.assertEqual(3, p[0])
        self.assertEqual(5, p[1])
        self.assertEqual(f'{p}', '(3, 5)')

    def test_pair_vector(self):
        v = pyFoo.pair_vector_output(3)
        self.assertEqual(3, len(v))

    def test_pair_jagged_array(self):
        v = pyFoo.pair_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i+1, len(v[i]))

    def test_pyFoo_static_methods(self):
        f = pyFoo.Foo()
        if __debug__:
            print(f'class Foo: ${dir(f)}')
        f.static_function(1)
        f.static_function(2147483647)
        f.static_function(2147483647+1)

    def test_pyFoo_int_methods(self):
        f = pyFoo.Foo()
        f.set_int(13)
        self.assertEqual(f.get_int(), 13)

    def test_pyFoo_int64_methods(self):
        f = pyFoo.Foo()
        f.set_int64(31)
        self.assertEqual(f.get_int64(), 31)

if __name__ == '__main__':
    unittest.main(verbosity=2)
