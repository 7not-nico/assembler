---
id:               RUST.OBJECT
language:         Rust
role:             object
title:            The value
definition:       A value expression is an expression that represents an actual value — the type of a value defines the interpretation of the memory holding it and the operations that may be performed on the value
sources:
  - section:      Rust Reference §Types
    url:          https://doc.rust-lang.org/reference/types.html
  - section:      Rust Reference §Expressions — Place expressions and value expressions
    url:          https://doc.rust-lang.org/reference/expressions.html#place-expressions-and-value-expressions
  - section:      Rust Reference §Expressions — Moved and copied types
    url:          https://doc.rust-lang.org/reference/expressions.html#moved-and-copied-types
canonical:        42
tags:             [value, rvalue, type, copy, move, sized, bit-pattern]
status:           draft
precedes:         []
---

## Object

The value. A bit pattern interpreted through its type. Every value belongs to exactly one type, which defines the interpretation of the underlying memory and the legal operations. Values are either **copied** (if the type implements `Copy`) or **moved** (if `Sized` and not `Copy`). Values have no identity — they are ephemeral results of expression evaluation.

### Core definition — types (§Types)

> Every variable, item, and value in a Rust program has a type. The type of a value defines the interpretation of the memory holding it and the operations that may be performed on the value.

The type is the schema of the Object. Without a type, a bit pattern has no meaning. The same byte pattern `0x41` is the integer `65`, the character `'A'`, or an invalid `bool` depending on its type.

### Value expression (§Expressions)

> A value expression is an expression that represents an actual value.

The Object is the result of evaluating a place expression in value context. When a place is used where a value is required, the compiler performs place-to-value coercion — the stored bits are read from the memory location and reinterpreted as a value:

```rust
let x: i32 = 42;          // 42: literal value (Object)
let y = x;                // x: place coerced to value (Object)
let z = x + 1;            // x + 1: operator produces value (Object)
let w = f();              // f(): function call produces value (Object)
```

### Type categories (§Types)

> Built-in types are tightly integrated into the language, in nontrivial ways that are not possible to emulate in user-defined types.
>
> User-defined types have limited capabilities.
>
> The list of types is:
>   Primitive types: bool, numeric, char, str, never (!)
>   Sequence types: tuple, array, slice
>   User-defined types: struct, enum, union
>   Function types: functions, closures
>   Pointer types: references, raw pointers, function pointers
>   Trait types: trait objects, impl trait

Each type category defines the Object's interpretation:

```rust
let b: bool = true;               // primitive — one byte, true or false
let c: char = 'A';                // primitive — Unicode scalar value
let t: (i32, f64) = (1, 2.0);    // tuple — compound value
let a: [i32; 3] = [1, 2, 3];     // array — fixed-size sequence
let s: &str = "hello";           // reference — pointer to string slice
let o: &dyn std::fmt::Display;   // trait object — type-erased value
```

### Copy vs Move (§Expressions — Moved and copied types)

> If the type of that value implements `Copy`, then the value will be copied.
>
> In the remaining situations, if that type is `Sized`, then it may be possible to move the value.
>
> After moving out of a place expression that evaluates to a local variable, the location is deinitialized and cannot be read from again until it is reinitialized.

The Object's runtime behavior splits on `Copy`:

```rust
let a: i32 = 42;          // i32: Copy — bitwise duplication
let b = a;                // both a and b are valid (copy)

let s = String::from("hello"); // String: not Copy — move semantics
let t = s;                     // s moved into t
// println!("{s}");            // ERROR: s deinitialized
```

### The never type (§Types)

> Never — `!` — a type with no values.

The Object can be impossible. Functions that never return (infinite loops, `panic!`, `process::exit`) produce values of type `!`, which coerces to any type:

```rust
fn never_returns() -> ! {
    loop {}
}
// let x: i32 = never_returns();  // ! coerces to i32
```

### Trait objects erase type (§Types)

> Trait objects — `dyn Trait`.

A trait object is an Object with its concrete type erased. The interpretation is dynamic — dispatch goes through a vtable:

```rust
fn print_it(v: &dyn std::fmt::Display) {
    println!("{v}");         // dynamic dispatch — type resolved at runtime
}
print_it(&42);
print_it(&"hello");
```

### Object sources

```rust
42                      // literal: immediate value
x + 1                   // operator: computed value
f()                     // function call: returned value
*ptr                    // dereference: value from memory
(x, y)                  // tuple: compound value
Copy                    // trait: value permits bitwise duplication
Move                    // semantics: value transfers ownership
```

## Summary

```
42                      // primitive Object: i32
true                    // primitive Object: bool
'a'                     // primitive Object: char
"hello"                 // primitive Object: &str
(1, 2.0)                // compound Object: (i32, f64)
[1, 2, 3]               // sequence Object: [i32; 3]
Point { x: 1, y: 2 }   // user-defined Object: struct
Ok(42)                  // user-defined Object: enum variant
dyn Display             // type-erased Object: trait object
!                       // empty Object: never type
```
