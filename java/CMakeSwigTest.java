package org.mizux.cmakeswig;

import org.mizux.cmakeswig.Loader;
import org.mizux.cmakeswig.bar.Bar;
import org.mizux.cmakeswig.foo.Foo;
import org.mizux.cmakeswig.foobar.FooBar;
import org.junit.jupiter.api.Test;

/** @author Mizux */
public class CMakeSwigTest {
  @Test
  public void testBar() {
    Loader.loadNativeLibraries();
    try {
      Bar.hello(1);
      Bar b = new Bar();
      b.setInt(42);
      System.out.printf("Bar int: %d\n", b.getInt());
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testFoo() {
    Loader.loadNativeLibraries();
    try {
      Foo.hello(1);
      Foo f = new Foo();
      f.setInt(42);
      System.out.printf("Foo int: %d\n", f.getInt());
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testFooBar() {
    Loader.loadNativeLibraries();
    try {
      FooBar.hello(1);
      FooBar fb = new FooBar();
      fb.setFooInt(11);
      fb.setBarInt(31);
      System.out.printf("FooBar int: %d\n", fb.getInt());
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }
}

