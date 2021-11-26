package org.mizux.cmakeswig;

import java.lang.ref.WeakReference;
import java.util.AbstractList;

import org.mizux.cmakeswig.Loader;
import org.mizux.cmakeswig.foobar.FooBar;
import org.mizux.cmakeswig.foobar.Globals;
import org.mizux.cmakeswig.foobar.StringVector;
import org.mizux.cmakeswig.foobar.StringJaggedArray;
import org.mizux.cmakeswig.foobar.IntPair;
import org.mizux.cmakeswig.foobar.PairVector;
import org.mizux.cmakeswig.foobar.PairJaggedArray;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/** @author Mizux */
public class FooBarTest {
  @Test
  public void testFreeFunctions() {
    Loader.loadNativeLibraries();
    try {
      Globals.freeFunction(32);
      Globals.freeFunction((long)64);
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testStaticMethods() {
    Loader.loadNativeLibraries();
    try {
      FooBar.staticFunction(32);
      FooBar.staticFunction((long)64);
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testStringVector() {
    Loader.loadNativeLibraries();
    try {
      {
        StringVector result = Globals.stringVectorOutput(5);
        System.out.printf("result.size(): %d\n", result.size());
        System.out.printf("{");
        for(int i=0; i < result.size(); ++i) {
          System.out.printf("%s, ", result.get(i));
        }
        System.out.printf("}\n");
      }
      {
        AbstractList<String> result = Globals.stringVectorOutput(5);
        System.out.printf("result.size(): %d\n", result.size());
        System.out.printf("{");
        for(int i=0; i < result.size(); ++i) {
          System.out.printf("%s, ", result.get(i));
        }
        System.out.printf("}\n");
      }
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testStringJaggedArray() {
    Loader.loadNativeLibraries();
    try {
      {
        AbstractList<StringVector> result = Globals.stringJaggedArrayOutput(5);
        System.out.printf("result.size(): %d\n", result.size());
        System.out.printf("{");
        for(int i=0; i < result.size(); ++i) {
          System.out.printf("{");
          AbstractList<String> inner = result.get(i);
          for(int j=0; j < inner.size(); ++j) {
            System.out.printf("%s,", inner.get(j));
          }
          System.out.printf("},");
        }
        System.out.printf("}\n");
      }
      {
        StringVector vec1 = new StringVector(new String[]{"1", "2", "3"});
        StringVector vec2 = new StringVector(new String[]{"4", "5"});
        StringJaggedArray jag = new StringJaggedArray(new StringVector[]{vec1, vec2});
        Globals.stringJaggedArrayInput(jag);
        Globals.stringJaggedArrayRefInput(jag);
      }
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testPairVector() {
    Loader.loadNativeLibraries();
    try {
      {
        PairVector result = Globals.pairVectorOutput(5);
        System.out.printf("result.size(): %d\n", result.size());
        System.out.printf("{");
        for(int i=0; i < result.size(); ++i) {
          IntPair p = result.get(i);
          System.out.printf("[%d,%d], ", p.getFirst(), p.getSecond());
        }
        System.out.printf("}\n");
      }
      {
        AbstractList<IntPair> result = Globals.pairVectorOutput(5);
        System.out.printf("result.size(): %d\n", result.size());
        System.out.printf("{");
        for(int i=0; i < result.size(); ++i) {
          IntPair p = result.get(i);
          System.out.printf("[%d,%d], ", p.getFirst(), p.getSecond());
        }
        System.out.printf("}\n");
      }
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testPairJaggedArray() {
    Loader.loadNativeLibraries();
    try {
      {
        AbstractList<PairVector> result = Globals.pairJaggedArrayOutput(5);
        System.out.printf("result.size(): %d\n", result.size());
        System.out.printf("{");
        for(int i=0; i < result.size(); ++i) {
          System.out.printf("{");
          AbstractList<IntPair> inner = result.get(i);
          for(int j=0; j < inner.size(); ++j) {
            System.out.printf("[%d,%d],", inner.get(j).getFirst(), inner.get(j).getSecond());
          }
          System.out.printf("},");
        }
        System.out.printf("}\n");
      }
      {
        PairVector vec1 = new PairVector(new IntPair[]{new IntPair(1,1), new IntPair(2,2), new IntPair(3,3)});
        PairVector vec2 = new PairVector(new IntPair[]{ new IntPair(4,4), new IntPair(5,5) });
        PairJaggedArray jag = new PairJaggedArray(new PairVector[]{vec1, vec2});
        Globals.pairJaggedArrayInput(jag);
        Globals.pairJaggedArrayRefInput(jag);
      }
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Test
  public void testFooBar() {
    Loader.loadNativeLibraries();
    try {
      FooBar f = new FooBar();
      f.setBarInt(11);
      f.setFooInt(31);
      assertEquals(42, f.getInt());

      f.setBarInt64((long)13);
      f.setFooInt64((long)51);
      assertEquals(64, f.getInt64());
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  private static void gc() {
    Object obj = new Object();
    WeakReference ref = new WeakReference<Object>(obj);
    obj = null;
    while(ref.get() != null) {
      System.gc();
    }
  }

  @ParameterizedTest
  @ValueSource(booleans = { false, true })
  public void testFooBarGC(boolean enableGC) throws Exception {
    Loader.loadNativeLibraries();
    FooBar f = new FooBar();
    f.setBarInt(11);
    f.setFooInt(31);
    f.setBarInt64((long)13);
    f.setFooInt64((long)51);
    if (enableGC) {
      gc();
    }
    assertEquals(42, f.getInt());
    assertEquals(64, f.getInt64());
    if (enableGC) {
      gc();
    }
  }
}
