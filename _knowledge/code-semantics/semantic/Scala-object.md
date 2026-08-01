---
id:               SCALA.OBJECT
language:         Scala
role:             object
title:            The expression value
definition:       "Expressions are composed of operators and operands. The typing of expressions is often relative to some expected type. Scala is a functional language in the sense that every function is a value"
sources:
  - section:      Scala 3.4 Spec §6 Expressions
    url:          https://www.scala-lang.org/files/archive/spec/3.4/06-expressions.html
  - section:      Scala 3.4 Spec §3 Types
    url:          https://www.scala-lang.org/files/archive/spec/3.4/03-types.html
  - section:      Scala Collections Overview
    url:          https://docs.scala-lang.org/overviews/collections-2.13/overview.html
canonical:        42
tags:             [expression, value, type, collection, function-value]
status:           draft
precedes:         []
---

## Object

The expression value. Every expression evaluates to a value, and every value is an object. Types classify values. Every function is a value — a first-class object that can be passed, stored, and composed.

### Every expression yields a value (§6)

> Expressions are composed of operators and operands.

```scala
42                    // literal → Int value
"hello"               // literal → String value
1 + 2                 // operator expression → 3
if (true) "a" else "b" // conditional expression → "a"
```

### Types as object classifiers (§3)

Types classify values. Scala's type system includes:

```scala
val x: Int = 42                    // simple type
val xs: List[Int] = List(1, 2, 3) // parameterized type
val p: (String, Int) = ("a", 1)   // tuple type
val f: Int => Int = _ + 1         // function type
val r: Range = 1 to 10            // range type
```

### Functions as values

> Scala is a functional language in the sense that every function is a value.

Functions are Objects of type `FunctionN[-T, +R]` with an `apply` method:

```scala
val inc: Int => Int = (x) => x + 1  // anonymous function
inc(10)                              // → 11
inc.apply(10)                        // same: apply method
```

### Collections as objects

> All collection classes are found in the package scala.collection or one of its sub-packages mutable and immutable.

```scala
val xs = List(1, 2, 3)               // immutable List
val ys = Vector("a", "b")            // immutable Vector
val m = Map("x" -> 1, "y" -> 2)     // immutable Map
val s = Set(1, 2, 3)                 // immutable Set
```

### Null and unit values

```scala
null                  // null reference (type Null)
()                    // unit value (type Unit)
```

## Summary

```
42                    // Int expression value
"hello"               // String expression value
List(1, 2)            // List collection value
(x: Int) => x + 1     // function value (anonymous)
if (c) a else b       // conditional expression value
()                    // unit value
```
