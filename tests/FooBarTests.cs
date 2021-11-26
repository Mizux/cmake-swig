using System;
using Xunit;
using Mizux.CMakeSwig.FooBar;

namespace Mizux.CMakeSwig.Tests {
  public class FooBarTest {
    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void IntegerTest(bool callGC) {
      // Instantiate FooBar
      FooBar.FooBar obj = new FooBar.FooBar();

      if (callGC) {
        GC.Collect();
      }

      obj.SetBarInt(3);
      obj.SetFooInt(5);
      Assert.Equal(8, obj.GetInt());

      obj.SetBarInt(11);
      obj.SetFooInt(31);
      Assert.Equal(42, obj.GetInt());
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void Integer64Test(bool callGC) {
      // Instantiate FooBar
      FooBar.FooBar obj = new FooBar.FooBar();

      if (callGC) {
        GC.Collect();
      }

      long a = 2147483647;
      long b = 2147483648;
      obj.SetBarInt64(a);
      obj.SetFooInt64(b);
      Assert.Equal(a+b, obj.GetInt64());
    }
  }
}
