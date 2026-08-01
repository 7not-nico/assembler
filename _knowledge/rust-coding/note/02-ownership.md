# Module 2 — Ownership

**Chapters**: Rust Book ch4
**Source**: https://doc.rust-lang.org/stable/book/ch04-01-what-is-ownership.html

## Key Concepts

### 4.1 — Ownership

**Ownership rules**
- Each value has an owner
- One owner at a time
- Value dropped when owner goes out of scope

**Stack vs Heap**
- Stack: LIFO, fixed size, fast
- Heap: dynamic size, slower, requires allocation
- Ownership exists to manage heap data

**String type** — heap-allocated, mutable, growable
- `String::from("hello")` — create from literal
- `.push_str("world")` — append

**Move** — assignment transfers ownership
- `let s2 = s1` — s1 is invalidated, s2 owns the data
- Rust never creates deep copies automatically
- Double-free prevented by invalidating source

**Clone** — explicit deep copy
- `let s2 = s1.clone()` — heap data copied, both valid

**Copy trait** — stack-only types, trivially copyable
- Integers, bools, floats, chars, tuples of Copy types
- `let y = x` — x is still valid for Copy types

**Function ownership**
- Passing value to function = move (unless Copy)
- Returning value = transfer ownership back
- Tuple returns: `(String, usize)` to give ownership back

### 4.2 — References and Borrowing

**Reference** — `&s` — borrow without taking ownership
- `fn length(s: &String) -> usize` — borrows, doesn't own

**Mutable reference** — `&mut s`
- `fn change(s: &mut String)` — can mutate through reference

**Reference rules**
- One mutable reference XOR any number of immutable references
- References must always be valid (no dangling references)

**Dangling reference** — Rust compiler prevents them at compile time

### 4.3 — Slices

**String slice** — `&str`, reference to part of a String
- `let hello = &s[0..5]` — range syntax
- `&s[..5]` — omit start
- `&s[0..]` — omit end
- `&s[..]` — entire string

**String literals** are slices: `&str` type

**Array slices** — `&[i32]`
- `let slice = &arr[1..3]`

## Fixtures

| File | Topic |
|------|-------|
| `fixtures/02-ownership.rs` | Move, Clone, Copy, function ownership |
| `fixtures/02-references.rs` | References, borrowing, mutable refs |
| `fixtures/02-slices.rs` | String slices, array slices |
