---
id:               JAVA.SUBJECT
language:         Java
role:             subject
title:            The class and its instance
definition:       The Java Virtual Machine starts execution by invoking a main method of some specified class or interface
sources:
  - section:      JLS §8 Classes
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-8.html
  - section:      JLS §12 Execution
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-12.html
  - section:      JLS §15.12.4 Run-Time Evaluation of Method Invocation
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-15.html#jls-15.12.4
canonical:        obj.method()
tags:             [class, instance, receiver, target-reference, this]
status:           draft
precedes:         [JAVA.OBJECT, JAVA.ACTION]
---

## Subject

The class and its instance. Java execution is class-centric — every method belongs to a class, every value is an instance of a class, execution starts with a class's `main` method.

### JVM startup (JLS §12.1)

> The Java Virtual Machine starts execution by invoking a `main` method of some specified class or interface.

The initial subject is a class. The JVM loads it, links it, initializes its static state, then invokes `main`. The subject at program start is the class itself.

### Object creation (JLS §12.5, §4.3.1)

> A new class instance is explicitly created when evaluation of a class instance creation expression (§15.9) causes a class to be instantiated.

> An object is a class instance or an array.

Subject shifts from class (static context) to instance (object context) when `new` creates an object. Each object carries its own state in instance fields.

### Class body (JLS §8)

> A class declaration defines a new class and describes how it is implemented.

The class body declares fields (Subject state), methods (Actions), and constructors (initialization). Fields persist across method calls on the same object.

### Target reference at invocation (JLS §15.12.4.1)

> At run time, method invocation requires five steps. First, a target reference may be computed.

```
obj.method()       // subject = obj (Primary.MethodName form)
this.field         // subject = this
super.method()     // subject = super (parent class instance)
ClassName.method() // subject = class (static — no target reference)
```

The target reference is the Subject. For instance methods, it is the receiver object. For static methods, there is no target reference — the class itself serves as subject.

## Summary

```
JVM starts           → subject = initial class (§12.1)
new instance         → subject = new object (§12.5, §8)
obj.method()         → subject = obj (target reference, §15.12.4.1)
static method        → subject = class (no target reference)
```

Subject is the carrier of state across Actions. In Java, it is always a class or an instance thereof, determined at invocation site by the target reference computation.
