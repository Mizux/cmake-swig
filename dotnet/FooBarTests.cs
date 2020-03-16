using System;
using Xunit;

using Mizux.CMakeSwig.FooBar;

namespace Mizux.CMakeSwig.Tests {
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
} // namespace Mizux.CMakeSwig.Tests

