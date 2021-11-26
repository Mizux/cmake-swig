package org.mizux.cmakeswig.examples;

import org.mizux.cmakeswig.Loader;
import org.mizux.cmakeswig.bar.Bar;
import org.mizux.cmakeswig.foo.Foo;
import org.mizux.cmakeswig.foobar.FooBar;

public final class Example {
  public static void main(String[] args) {
    Loader.loadNativeLibraries();

    Bar b = new Bar();
    b.setInt(3);
    System.out.println("Bar: " + b.getInt());

    Foo f = new Foo();
    f.setInt(5);
    System.out.println("Foo: " + f.getInt());

    FooBar fb = new FooBar();
    fb.setBarInt(11);
    fb.setFooInt(31);
    System.out.println("FooBar: " + fb.getInt());
  }

  private Example() {}
}
