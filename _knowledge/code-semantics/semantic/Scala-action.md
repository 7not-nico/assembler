---
id:               SCALA.ACTION
language:         Scala
role:             action
title:            The method and function application
definition:       "The typing of expressions is often relative to some expected type. Scala provides higher-order functions, nesting of function definitions, and pattern matching. Every function is a value"
sources:
  - section:      Scala 3.4 Spec §6 Expressions
    url:          https://www.scala-lang.org/files/archive/spec/3.4/06-expressions.html
  - section:      Scala 3.4 Spec §6.6 Method Applications
    url:          https://www.scala-lang.org/files/archive/spec/3.4/06-expressions.html#method-applications
  - section:      Scala 3.4 Spec §8 Pattern Matching
    url:          https://www.scala-lang.org/files/archive/spec/3.4/08-pattern-matching.html
  - section:      Scala 3.4 Spec §6.18 For Comprehensions
    url:          https://www.scala-lang.org/files/archive/spec/3.4/06-expressions.html#for-comprehensions-and-for-loops
canonical:        f(x)
tags:             [method, function, application, pattern-match, for-comprehension]
status:           draft
precedes:         []
---

## Action

The method and function application. Scala has two fundamental action forms: method application (`obj.method(args)`) and function application (`f(args)`, syntactic sugar for `f.apply(args)`). Pattern matching provides multi-branch selection. For comprehensions sequence actions.

### Method application (§6.6)

> Method application: `SimpleExpr '.' id ArgumentExprs`

```scala
val xs = List(1, 2, 3)
xs.length            // method call: length on xs
xs.map(_ * 2)        // method call: map with anonymous function
```

### Function application

> Every function is a value. Functions correspond to `FunctionN` objects with an `apply` method.

```scala
val inc = (x: Int) => x + 1  // function value
inc(10)                       // desugars to inc.apply(10)

// Higher-order function application:
List(1, 2, 3).map(inc)        // → List(2, 3, 4)
List(1, 2, 3).filter(_ > 1)  // → List(2, 3)
```

### Pattern matching (§8)

Pattern matching selects among alternatives — it is the primary branching Action:

```scala
x match {
  case 0      => "zero"
  case n if n > 0 => "positive"
  case _      => "negative"
}

// Case class deconstruction:
case class Person(name: String, age: Int)
val p = Person("Alice", 30)
p match {
  case Person(n, a) => s"$n is $a years old"
}
```

### Conditional and loop actions (§6)

All control flows are expressions that return values:

```scala
val result = if (x > 0) "positive" else "non-positive"

var i = 0
while (i < 10) {
  println(i)
  i += 1
}
```

### For comprehensions (§6.18)

For comprehensions sequence and combine actions over collections:

```scala
val result = for {
  x <- List(1, 2, 3)       // iterate (flatMap)
  y <- List(10, 20)        // nested iteration
} yield x + y               // → List(11, 21, 12, 22, 13, 23)

// Without yield: side-effecting loop
for {
  i <- 1 to 3
  j <- 1 to i
} print(s"$i,$j ")
```

### Block and expression sequencing (§6.11)

Blocks group multiple statements; the last expression is the value:

```scala
val result = {
  val x = 1
  val y = 2
  x + y               // block value: 3
}
```

## Summary

```
obj.method(args)      // method application
f(args)               // function application (f.apply)
x match { case ... }   // pattern matching
if (c) a else b       // conditional
for { x <- xs } yield x  // for comprehension
{ stmt; expr }        // block: last expression is value
```
