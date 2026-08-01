---
id:               C.SUBJECT
language:         C
role:             subject
title:            The lvalue
definition:       An lvalue is an expression with an object type or an incomplete type other than void — it represents an object "locator value"
sources:
  - section:      ISO/IEC 9899:1999 §6.3.2.1 Lvalues
    url:          https://c0x.shape-of-code.com/6.3.2.1.html
  - section:      ISO/IEC 9899:1999 §6.7 Declarations
    url:          https://c0x.shape-of-code.com/6.7.html
  - section:      ISO/IEC 9899:1999 §6.5.16 Assignment operators
    url:          https://c0x.shape-of-code.com/6.5.16.html
canonical:        int x; x = 42;
tags:             [lvalue, identity, persistence, locator]
status:           draft
precedes:         [C.OBJECT, C.ACTION]
---

## Subject

The lvalue. An expression that designates an object with identity and persistence. The C standard defines it as a "locator value" — the thing that carries state across the execution sequence.

### Core definition (§6.3.2.1)

> 717 An lvalue is an expression with an object type or an incomplete type other than void.
>
> 730 The name "lvalue" comes originally from the assignment expression E1 = E2, in which the left operand E1 is required to be a (modifiable) lvalue.
>
> 731 It is perhaps better considered as representing an object "locator value".
>
> 733 An obvious example of an lvalue is an identifier of an object.

The Subject is the locator — it identifies a storage location, not the value stored there.

### Subject creation (§6.7)

> 1344 A definition of an identifier for an object causes storage to be reserved for that object.

Declarations create Subjects. `int x;` reserves storage for an int object — a Subject is born.

### Subject receives value (§6.5.16)

> 1279 An assignment operator shall have a modifiable lvalue as its left operand.
>
> 1280 An assignment operator stores a value in the object designated by the left operand.

The Subject is the target of assignment. The left operand of `=` is always an lvalue. The right operand's value is stored into it.

### Subject state changes (§5.1.2.3)

> 183 Accessing a volatile object, modifying an object, modifying a file, or calling a function that does any of those operations are all side effects, which are changes in the state of the execution environment.
>
> 185 At certain specified points in the execution sequence called sequence points, all side effects of previous evaluations shall be complete and no side effects of subsequent evaluations shall have taken place.

The Subject's stored value changes are side effects. The execution model guarantees that between sequence points, Subject state is consistent.

### Subject forms

```c
int x;            // declaration: Subject created
x = 42;           // lvalue = assignment target
*ptr = 10;        // dereference: Subject via pointer
arr[i] = 5;       // subscript: Subject is array element
s.field = 'a';    // member access: Subject is struct member
```

Subject persists across sequence points. It carries state until its storage duration ends.
