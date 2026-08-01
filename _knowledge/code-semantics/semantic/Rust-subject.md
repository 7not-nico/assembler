---
id:               RUST.SUBJECT
language:         Rust
role:             subject
title:            The place
definition:       A place expression is an expression that represents a memory location
sources:
  - section:      Rust Reference §Expressions — Place expressions and value expressions
    url:          https://doc.rust-lang.org/reference/expressions.html#place-expressions-and-value-expressions
  - section:      Rust Reference §Items
    url:          https://doc.rust-lang.org/reference/items.html
  - section:      Rust Reference §Types
    url:          https://doc.rust-lang.org/reference/types.html
canonical:        let x; x = 42;
tags:             [place, lvalue, memory-location, ownership, borrow, lifetime, mutability]
status:           draft
precedes:         [RUST.OBJECT, RUST.ACTION]
---

## Subject

The place. A memory location identified by a path, with an owner, borrow state (`&` / `&mut`), lifetime, and mutability. Rust's Subject is dual: a **static Item** at compile time and a **dynamic Place** at runtime. The borrow checker verifies that every Subject access respects ownership and lifetime rules.

### Core definition — place expressions (§Expressions)

> A place expression is an expression that represents a memory location.
>
> These expressions are paths which refer to local variables, static variables, dereferences (`*expr`), array indexing expressions (`expr[expr]`), field references (`expr.f`) and parenthesized place expressions.

The Subject is a memory location, not a value. A variable, a struct field, an array element, a dereferenced pointer — each is a place. The location persists while the borrow is active.

### Items as static Subjects (§Items)

> Items are entirely determined at compile-time, generally remain fixed during execution, and may reside in read-only memory.

Static Subjects — modules, structs, enums, unions, functions, traits, impls, constants, statics — are compile-time definitions. They define the shape of dynamic places:

```rust
struct Point { x: i32, y: i32 }    // item: defines shape of Subject
static MAX: u32 = 100;              // item: read-only static place
fn foo() {}                         // item: function, callable Subject
```

### Ownership and borrow state (§Expressions)

> Only the following place expressions may be moved out of:
>   - Variables which are not currently borrowed.
>   - Temporary values.
>   - Fields of a place which can be moved out of and don't implement Drop.
>   - The result of dereferencing an expression with type `Box<T>`.

Every place has a borrow-checker-verified state: **owned**, **immutably borrowed** (`&T`), or **mutably borrowed** (`&mut T`). A place may be moved from only when not borrowed:

```rust
let s = String::from("hello");  // s: owned place
let r = &s;                     // s: immutably borrowed — read-only
// drop(s);                     // ERROR: cannot move out of borrowed place
```

### Mutability is a place property (§Expressions)

> For a place expression to be assigned to, mutably borrowed, implicitly mutably borrowed, or bound to a pattern containing `ref mut`, it must be mutable.

Mutability is not a property of the value — it is a property of the place:

```rust
let mut x = 42;     // x: mutable place
let y = x;          // x is moved; y: immutable place
// y = 43;          // ERROR: y is not mutable
```

### Place expression contexts (§Expressions)

> The following contexts are place expression contexts:
>   - The left operand of a compound assignment expression.
>   - The operand of a unary borrow, raw borrow or dereference operator.
>   - The operand of a field expression.
>   - The indexed operand of an array indexing expression.
>   - The tuple operand of a tuple indexing expression.
>   - The operand of any implicit borrow.
>   - The initializer of a `let` statement.
>   - The scrutinee of an `if let`, `match`, or `while let` expression.
>   - The base of a functional update struct expression.

These contexts demand a place, not a value. The compiler requires a memory location for each:

```rust
let x = 42;          // let initializer: place context
let r = &x;          // borrow operand: place context
let f = p.y;         // field operand: place context
match x {            // scrutinee: place context (implicit borrow)
    0 => println!("zero"),
    _ => {},
}
```

### Lifetime annotation (§Reference — type paths)

Places carry lifetime annotations when they are references. The lifetime connects the place to its origin:

```rust
fn first<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
    // return place borrows from x or y — lifetime 'a ensures validity
}
```

### Subject forms

```rust
let x: i32;              // local variable place
static MAX: u32 = 100;   // static place (read-only memory)
x = 42;                  // assignment target — mutable place
*p = 10;                 // dereference — place via pointer
arr[i] = 5;              // index — place is array element
s.field = 'a';           // field access — place is struct member
&mut x;                  // borrow — place in place context
```

## Summary

```
item::struct Point       // static Subject: compile-time definition
let mut x: i32           // dynamic Subject: mutable memory location
*x                       // dereference: place via pointer
p.field                  // field: place within a struct
arr[i]                   // index: place within a collection
&x / &mut x              // borrow: place with restricted access
lifetime: 'a             // place validity annotation
```
