---
id:               RUST.ACTION
language:         Rust
role:             action
title:            The evaluation
definition:       An expression evaluates to a value, and has effects during evaluation — the structure of expressions dictates the structure of execution
sources:
  - section:      Rust Reference §Expressions
    url:          https://doc.rust-lang.org/reference/expressions.html
  - section:      Rust Reference §Expressions — Place expressions and value expressions
    url:          https://doc.rust-lang.org/reference/expressions.html#place-expressions-and-value-expressions
  - section:      Rust Reference §Expressions — Moved and copied types
    url:          https://doc.rust-lang.org/reference/expressions.html#moved-and-copied-types
  - section:      Rust Reference §Expressions — Evaluation order of operands
    url:          https://doc.rust-lang.org/reference/expressions.html#evaluation-order-of-operands
canonical:        let x = 42;
tags:             [expression, evaluation, place-to-value, move, borrow-check, side-effect]
status:           draft
precedes:         []
---

## Action

The evaluation of an expression. Every Action produces a value (Object) and may have side effects. The core Action is **place-to-value coercion** — a Place (Subject) is read to produce a Value (Object). The borrow checker verifies that each coercion is legal: the Place must not be moved-out, mutably borrowed while read, or immutably borrowed while written.

### Core definition (§Expressions)

> An expression evaluates to a value, and has effects during evaluation.
>
> The structure of expressions dictates the structure of execution. Blocks are just another kind of expression, so blocks, statements, expressions, and blocks again can recursively nest inside each other to an arbitrary depth.

Execution is nested expression evaluation. There is no statement/expression split — blocks, loops, and conditionals are all expressions:

```rust
let x = {              // block expression: Action
    let y = 42;        // let statement: binds place
    y + 1              // trailing expression: produces Object 43
};

let z = if x > 0 {     // if expression: Action
    x * 2
} else {
    0
};
```

### Expression grammar (§Expressions)

```
Expression:
    ExpressionWithoutBlock    (literal, path, operator, call, field, ...)
    ExpressionWithBlock       (block, const block, unsafe block, loop, if, match)
```

Every syntactic form is an Action. Each defines: whether operands are evaluated, in what order, and how their values combine:

```rust
42                          // literal expression: value immediate
f(x)                        // call expression: evaluate f, evaluate x, call
a + b                       // operator expression: evaluate a, evaluate b, add
if cond { t } else { f }    // if expression: evaluate cond, branch
match v { P => e }          // match expression: evaluate v, pattern-match, evaluate arm
loop { break 42 }           // loop expression: evaluate to 42 via break
unsafe { *p = 42 }          // unsafe block: Action with relaxed borrow-check
```

### Place-to-value coercion (§Expressions)

> A place expression is an expression that represents a memory location.
>
> A value expression is an expression that represents an actual value.
>
> When a place expression is evaluated in a value expression context, or is bound by value in a pattern, it denotes the value held in that memory location.

The fundamental Action is converting a Subject (Place) into an Object (Value). This is the lvalue-to-rvalue conversion:

```rust
let x: i32 = 42;        // declaration: creates Place (Subject)
let y = x;              // Action: Place → Value — read x, produce Object
//                      //   borrow-checker: x is not borrowed, OK to read
```

If the Place is borrowed, the coercion is still legal if the borrow is compatible:

```rust
let s = String::from("hi");
let r = &s;              // Action: borrow — Place &s created
println!("{r}");         // Action: Place → Value through shared reference
// let t = s;            // Action: would move — ERROR, s is borrowed
```

### Move and copy semantics (§Expressions — Moved and copied types)

> If the type of that value implements `Copy`, then the value will be copied.
>
> In the remaining situations, if that type is `Sized`, then it may be possible to move the value.
>
> Only the following place expressions may be moved out of:
>   - Variables which are not currently borrowed.
>   - Temporary values.
>   - Fields of a place expression which can be moved out of and don't implement `Drop`.
>   - The result of dereferencing an expression with type `Box<T>` and that can also be moved out of.
>
> After moving out of a place expression that evaluates to a local variable, the location is deinitialized and cannot be read from again until it is reinitialized.

The Action's effect on the Subject depends on Copy vs Move:

```rust
// Copy Action — Subject stays valid
let a: i32 = 42;
let b = a;                // Action: copy — both a and b are valid
println!("{a} {b}");      // OK

// Move Action — Subject deinitialized
let s = String::from("hi");
let t = s;                // Action: move — s deinitialized
println!("{t}");          // OK
// println!("{s}");       // ERROR: s deinitialized

// Reinitialization — Subject becomes valid again
let mut x = String::from("a");
*x = String::from("b");   // Action: assignment — reinitializes Place
let y = x;                // Action: move — x deinitialized
x = String::from("c");    // Action: reinitialization — x valid again
```

### Evaluation order (§Expressions — Evaluation order of operands)

> The operands of these expressions are evaluated prior to applying the effects of the expression. Expressions taking multiple operands are evaluated left to right as written in the source code.

Rust guarantees left-to-right evaluation of operands, unlike C (unspecified order):

```rust
let mut v = vec![1, 2, 3];
let r = v.pop().unwrap() + v.pop().unwrap();
// v.pop() (left operand) evaluated first → 3
// v.pop() (right operand) evaluated second → 2
// addition → 5
```

### Mutability gates — write Action (§Expressions — Mutability)

> For a place expression to be assigned to, mutably borrowed, implicitly mutably borrowed, or bound to a pattern containing `ref mut`, it must be mutable. We call these mutable place expressions.

Write Actions require a mutable Place. The borrow checker enforces this at compile time:

```rust
let mut x = 42;           // mutable Place
x = 43;                   // Action: write — OK, x is mutable

let y = 42;               // immutable Place
// y = 43;                // ERROR: y is not mutable

let r = &mut x;           // Action: mutable borrow — requires mutable Place
*r = 44;                  // Action: write through mutable reference
```

### Borrow-check gate on Action

The borrow checker evaluates every Action before execution. It verifies:

| Action | Subject State Required |
|--------|------------------------|
| Read (place→value) | Not currently mutably borrowed |
| Write (assignment) | Mutable + not currently borrowed |
| Move (transfer) | Not currently borrowed (any kind) |
| Borrow `&T` | Not currently mutably borrowed |
| Borrow `&mut T` | Mutable + not currently borrowed (any kind) |

```rust
let mut x = 42;
let r1 = &x;              // Action: shared borrow — OK
let r2 = &x;              // Action: shared borrow — OK (multiple readers)
println!("{r1} {r2}");    // Action: reads through shared borrows — OK
let r3 = &mut x;          // ERROR: cannot borrow as mutable while immutably borrowed
```

### Action kinds

```rust
x = 42;                    // assignment: write to mutable Place
x + 1                      // operator: read Places, produce Value
f(x)                       // call: evaluate arguments, invoke
if cond { a } else { b }  // branch: evaluate condition, select arm
match v { P => e }         // match: evaluate scrutinee, pattern-match
loop { break v }           // loop: repeat, break produces Value
return x                   // return: exit, produce Value
let x = v;                 // bind: creates Place, assigns Value
{ expr }                   // block: sequential evaluation, trailing = Value
unsafe { expr }            // unsafe: relaxed borrow-check on Action
```

## Cycle

```rust
let mut acc = 0;            // Action: bind — Subject created, mutable
let vals = vec![1, 2, 3];   // Action: bind — Subject created, owned
for v in &vals {            // Action: iterate — implicit borrow
    acc = acc + v;          // Action: read acc, read v, add, write acc
}
println!("{acc}");          // Action: read acc, produce formatted string
```

Every Rust program reduces to this cycle: bind creates a Place, expression evaluates read/write/move Actions on it, the borrow checker gates every transition, and the Place persists until its scope ends.
