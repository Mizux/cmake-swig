package org.mizux.javanative.examples;

import org.mizux.javanative.Loader;
import org.mizux.javanative.bar.Bar;
import org.mizux.javanative.foo.Foo;
import org.mizux.javanative.foobar.FooBar;

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
