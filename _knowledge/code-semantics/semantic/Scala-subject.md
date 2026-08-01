---
id:               SCALA.SUBJECT
language:         Scala
role:             subject
title:            The object
definition:       "Scala is a pure object-oriented language in the sense that every value is an object. Types and behavior of objects are described by classes. Classes can be composed using mixin composition"
sources:
  - section:      Scala 3.4 Spec Preface
    url:          https://www.scala-lang.org/files/archive/spec/3.4/
  - section:      Scala 3.4 Spec §5 Classes & Objects
    url:          https://www.scala-lang.org/files/archive/spec/3.4/05-classes-and-objects.html
  - section:      Scala Collections Overview
    url:          https://docs.scala-lang.org/overviews/collections-2.13/overview.html
canonical:        "val x: Int = 42"
tags:             [object, class, trait, case-class, instance, value]
status:           draft
precedes:         [SCALA.OBJECT, SCALA.ACTION]
---

## Subject

The object. Scala is a pure object-oriented language where every value is an object. Classes, traits, case classes, and singleton objects define the shape and behavior of Subjects. Objects carry state through mutable or immutable fields.

### Every value is an object (§Preface)

> Scala is a pure object-oriented language in the sense that every value is an object. Types and behavior of objects are described by classes. Classes can be composed using mixin composition.

```scala
val x: Int = 42      // 42 is an Int object
val s: String = "hi" // "hi" is a String object
val f: (Int) => Int = _ + 1  // function is an object
```

### Class as subject template (§5)

Classes define the shape of Subjects — their fields (state) and methods (actions):

```scala
class Counter(var count: Int) {
  def increment(): Unit = count += 1
  def current(): Int = count
}

val c = new Counter(0)  // c is a Subject with state count = 0
c.increment()           // action changes Subject state
c.current()             // → 1
```

### Case classes as immutable subjects

Case classes provide immutable state carriers with structural equality:

```scala
case class Person(name: String, age: Int)  // immutable Subject
val p = Person("Alice", 30)                 // no 'new' needed
val older = p.copy(age = 31)               // new Subject with changed field
```

### Singleton object (§5)

Scala's `object` keyword creates a singleton — exactly one instance:

```scala
object Config {
  val timeout = 5000
  def load(): Unit = ???
}
// Config is the sole Subject of its type
```

### mutable vs immutable state

> Scala collections systematically distinguish between mutable and immutable collections. By default, Scala always picks immutable collections.

```scala
val imm = List(1, 2, 3)       // immutable — content never changes
val mut = mutable.ListBuffer(1, 2, 3)  // mutable — can add/remove
```

## Summary

```
val x: Int = 42           // object with value
class C(s: String) { }    // class defines Subject shape
case class P(n: String)   // immutable Subject
object S { }              // singleton Subject
val xs: List[Int]         // immutable collection Subject
```
