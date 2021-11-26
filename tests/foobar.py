#!/usr/bin/env python3
'''Test APIs'''

import unittest
import cmakeswig
from cmakeswig.foobar import pyFooBar
#import cmakeswig.foobar.pyFooBar as foobar

if __debug__:
    print(f'version: {cmakeswig.__version__}')
    print(f'cmakeswig: ${dir(cmakeswig)}')
    print(f'cmakeswig.foobar: ${dir(cmakeswig.foobar)}')
    print(f'pyFooBar: ${dir(pyFooBar)}')


class TestpyFooBar(unittest.TestCase):
    '''Test pyFooBar'''
    def test_free_function(self):
        pyFooBar.free_function(2147483647) # max int
        pyFooBar.free_function(2147483647+1) # max int + 1

    def test_string_vector(self):
        v = pyFooBar.string_vector_output(3)
        self.assertEqual(8, len(v))

    def test_string_jagged_array(self):
        v = pyFooBar.string_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i+1, len(v[i]))
        self.assertEqual(
                3,
                pyFooBar.string_jagged_array_input([['1'],['2','3'],['4','5','6']]))

    def test_int_pair(self):
        p = pyFooBar.IntPair(3, 5)
        if __debug__:
            print(f"class IntPair: {dir(p)}")
        self.assertEqual(3, p[0])
        self.assertEqual(5, p[1])
        self.assertEqual(f'{p}', '(3, 5)')

    def test_pair_vector(self):
        v = pyFooBar.pair_vector_output(3)
        self.assertEqual(8, len(v))

    def test_pair_jagged_array(self):
        v = pyFooBar.pair_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i+1, len(v[i]))

    def test_pyFooBar_static_methods(self):
        f = pyFooBar.FooBar()
        if __debug__:
            print(f'class FooBar: ${dir(f)}')
        f.static_function(1)
        f.static_function(2147483647)
        f.static_function(2147483647+1)

    def test_pyFooBar_int_methods(self):
        f = pyFooBar.FooBar()
        f.set_foo_int(13)
        f.set_bar_int(17)
        self.assertEqual(30, f.get_int())

    def test_pyFooBar_int64_methods(self):
        f = pyFooBar.FooBar()
        f.set_foo_int64(31)
        f.set_bar_int64(37)
        self.assertEqual(68, f.get_int64())

if __name__ == '__main__':
    unittest.main(verbosity=2)
