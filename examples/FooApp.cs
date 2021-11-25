using System;
using Mizux.DotnetNative;

namespace Mizux.DotnetNative.FooApp {
  class Program {
    static void Main(string[] args) {
      int level = 1;
      Console.WriteLine($"[{level}] Enter DotnetNativeApp");
      Foo.StaticFunction(level+1);
      Console.WriteLine($"[{level}] Exit DotnetNativeApp");
    }
  }
}
