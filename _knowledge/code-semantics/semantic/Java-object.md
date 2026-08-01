---
id:               JAVA.OBJECT
language:         Java
role:             object
title:            The typed value
definition:       The Java programming language is a statically typed language — every variable and every expression has a type known at compile time
sources:
  - section:      JLS §4 Types, Values, and Variables
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-4.html
  - section:      JLS §15.1 Evaluation, Denotation, and Result
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-15.html
  - section:      JLS §15.6 Normal and Abrupt Completion of Evaluation
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-15.html
canonical:        int x = 5;
tags:             [primitive, reference, type, value, strong-typing]
status:           draft
precedes:         []
---

## Object

The typed value. Java is statically and strongly typed — every expression produces a value of a known type, every variable holds a value of a declared type.

### Type system (JLS §4)

> The Java programming language is a statically typed language, which means that every variable and every expression has a type that is known at compile time.

> The Java programming language is also a strongly typed language, because types limit the values that a variable (§4.12) can hold or that an expression can produce, limit the operations supported on those values, and determine the meaning of the operations.

### Two kinds of values (JLS §4.1)

> There are, correspondingly, two kinds of data values that can be stored in variables, passed as arguments, returned by methods, and operated on: primitive values (§4.2) and reference values (§4.3).

```java
int x = 5;              // object = primitive value (5)
String s = "hello";     // object = reference value (points to String object)
double d = x + 3.0;     // object = primitive value (8.0) from numeric promotion
```

### Objects as class instances (JLS §4.3.1)

> An object is a class instance or an array.

> The reference values (often just references) are pointers to these objects, and a special null reference, which refers to no object.

```java
Point p = new Point(0,0);     // object = reference to Point instance
int[] arr = {1, 2, 3};        // object = reference to array
String s = null;              // object = null reference (points to nothing)
```

### Variables as storage (JLS §4.12)

> A variable is a storage location and has an associated type, sometimes called its compile-time type, that is either a primitive type (§4.2) or a reference type (§4.3).

Variables are the named Object holders. Assignment replaces the Object held. Subtyping allows a variable of type T to hold a reference to an instance of any subclass of T.

### Expression results (JLS §15.1)

> When an expression in a program is evaluated (executed), the result denotes one of three things: a variable (an lvalue), a value, or nothing (void).

```
obj.field             → object = value at field
method()              → object = return value (or void)
a + b                 → object = primitive result of operation
```

### Completion model (JLS §15.6)

> Every expression has a normal mode of evaluation in which certain computational steps are carried out. If all the steps are carried out without an exception being thrown, the expression is said to complete normally.

> If, however, evaluation of an expression throws an exception, then the expression is said to complete abruptly.

Objects are ephemeral unless stored in a variable or field. Expression results flow into containing statements, get passed as arguments, or are discarded.

## Summary

```
literal              → object = primitive or String value
new Class()          → object = reference to heap-allocated instance
variable read        → object = value currently held in that variable
method return        → object = value produced by method body
null                 → object = null reference (type-safe absence)
```

Object is the value produced by expressions, constrained by the static type system, consumed by actions, and carried by subjects across method boundaries.
