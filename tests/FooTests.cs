using System;
using Xunit;
using Mizux.DotnetNative;

namespace Mizux.DotnetNative.Tests {
  public class FooTest {
    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void IntegerTest(bool callGC) {
      // Instantiate Foo
      Foo obj = new Foo();

      if (callGC) {
        GC.Collect();
      }

      obj.SetInt(42);
      Assert.Equal(42, obj.GetInt());
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void Integer64Test(bool callGC) {
      // Instantiate Foo
      Foo obj = new Foo();

      if (callGC) {
        GC.Collect();
      }

      long a = 2147483647;
      obj.SetInt64(a);
      Assert.Equal(a, obj.GetInt64());

      long b = 2147483648;
      obj.SetInt64(b);
      Assert.Equal(b, obj.GetInt64());
    }
  }
}
