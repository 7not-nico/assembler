---
id:               C.OBJECT
language:         C
role:             object
title:            The rvalue
definition:       What is sometimes called "rvalue" is described as the "value of an expression"
sources:
  - section:      ISO/IEC 9899:1999 §6.3.2.1 (rvalue footnote)
    url:          https://c0x.shape-of-code.com/6.3.2.1.html
  - section:      ISO/IEC 9899:1999 §6.5 Expressions
    url:          https://c0x.shape-of-code.com/6.5.html
  - section:      ISO/IEC 9899:1999 §6.5.16 Assignment operators
    url:          https://c0x.shape-of-code.com/6.5.16.html
canonical:        42
tags:             [rvalue, value, transient, expression]
status:           draft
precedes:         []
---

## Object

The rvalue. The value produced by an expression. The C standard does not define "rvalue" as a term — it notes the term in a footnote and describes it as the "value of an expression."

### Core definition (§6.3.2.1)

> 732 What is sometimes called "rvalue" is in this International Standard described as the "value of an expression".

The Object is not a kind of expression — it is the *result* of evaluating an expression. Unlike an lvalue, it has no identity and no storage location.

### Expression evaluation (§6.5)

> 933 An expression is a sequence of operators and operands that specifies computation of a value, or that designates an object or a function, or that generates side effects, or that performs a combination thereof.

The Object is the computed value. An expression designates an object (Subject) or computes a value (Object). The same syntax produces either depending on context — a name used as lvalue (Subject) or as rvalue (Object).

### Lvalue conversion (§6.3.2.1)

> 721 Except when it is the operand of the `sizeof` operator, the unary `&` operator, the `++` operator, the `--` operator, or the left operand of the `.` operator or an assignment operator, an lvalue that does not have array type is converted to the value stored in the designated object (and is no longer an lvalue).

When an lvalue (Subject) is used where a value is needed, it converts to an rvalue (Object). The storage identity is lost; only the value remains. This is the Subject-to-Object transition.

### Object sources

```c
x = 42;           // 42: literal constant (Object)
x = y + 1;        // y + 1: expression result (Object)
x = f();          // f(): function return value (Object)
x = arr[i];       // arr[i] converted to its stored value (Object)
```

### Assignment produces an Object (§6.5.16)

> 1281 An assignment expression has the value of the left operand after the assignment, but is not an lvalue.

The assignment itself produces an Object (the value assigned). This allows chaining: `a = b = c` — the inner assignment evaluates to the Object `c`, which is then stored into `a`.

Objects are ephemeral. They parameterize the Action and disappear. They persist only when stored into a Subject (lvalue).
