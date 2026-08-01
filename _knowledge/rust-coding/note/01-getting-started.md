# Module 1 — Getting Started

**Chapters**: Rust Book ch1-3
**Source**: https://doc.rust-lang.org/book/ch01-00-getting-started.html

## Key Concepts

### ch1 — Toolchain
- `rustup` — toolchain manager. Install/update/switch Rust versions
- `rustc` — compiler. `rustc main.rs && ./main`
- `cargo` — package manager + build system. `cargo new`, `cargo build`, `cargo run`, `cargo check`
- `cargo check` — fast type-check without producing binary. Prefer during dev

### ch3.1 — Variables & Mutability
- **Immutable by default**: `let x = 5` — cannot reassign
- **Mutable**: `let mut x = 5` — can reassign with `x = 6`
- **Constants**: `const MAX: u32 = 100` — always immutable, type must be annotated. `const` keyword
- **Shadowing**: `let x = 5; let x = x + 1;` — new variable shadows old. Different type allowed

### ch3.2 — Data Types
- **Scalar**: integers (`i8, u8, i16, u16, i32, u32, i64, u64, i128, u128, isize, usize`), floats (`f32, f64`), bool (`bool`), char (`char` — 4 bytes, Unicode)
- **Compound**: tuples `(i32, f64, u8)`, arrays `[i32; 5]`
- Tuples destructure: `let (x, y, z) = tup;`; access by index: `tup.0`
- Arrays fixed-length, stack-allocated: `let a: [i32; 5] = [1,2,3,4,5];`; access: `a[0]`
- Type inference works. Annotate when needed: `let x: u32 = 5;`

### ch3.3 — Functions
- `fn name(param: Type) -> ReturnType { body }`
- Expression-based: last expression is return value (no semicolon)
- `return` keyword for early return

### ch3.5 — Control Flow
- `if condition { } else { }` — condition must be `bool`, no coercion
- `let result = if cond { a } else { b };` — if is expression
- **Loops**: `loop { }` (infinite, break with `break`), `while cond { }`, `for element in iter { }`
- `for number in (1..4).rev()` — range with reverse

## Fixtures

| File | Topic |
|------|-------|
| `fixtures/01-hello.rs` | Hello World, println!, rustc workflow |
| `fixtures/01-vars.rs` | Variables, mutability, types, shadowing |
| `fixtures/01-control.rs` | Functions, if/else, loops, for/while |
