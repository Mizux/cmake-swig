using System;
using Xunit;

using Mizux.CMakeSwig.Foo;
using Mizux.CMakeSwig.Bar;
using Mizux.CMakeSwig.FooBar;

namespace Mizux.Sample {
  public class FooTest {
    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void GetterTest(bool callGC) {
      // Instantiate Foo
      Foo obj = new Foo(42);

      if (callGC) {
        GC.Collect();
      }

      Assert.Equal(42, obj.GetValue());
    }
  }

  public class BarTest {
    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void GetterTest(bool callGC) {
      // Instantiate Bar
      Bar obj = new Bar(42);

      if (callGC) {
        GC.Collect();
      }

      Assert.Equal(42, obj.GetValue());
    }
  }

  public class FooBarTest {
    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void GetterTest(bool callGC) {
      // Instantiate FooBar
      FooBar obj = new FooBar(42);

      if (callGC) {
        GC.Collect();
      }

      Assert.Equal(42, obj.GetValue());
    }
  }
} // namespace Mizux.Sample
