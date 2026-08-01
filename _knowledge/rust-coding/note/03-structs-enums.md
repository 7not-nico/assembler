# Module 3 — Structs & Enums

**Chapters**: Rust Book ch5-6
**Source**: https://doc.rust-lang.org/stable/book/ch05-01-defining-structs.html

## Key Concepts

### 5.1 — Structs

**Struct definition** — custom data type, fields named and typed
```
struct User {
    name: String,
    email: String,
}
```

**Instantiation** — provide values for all fields
```
let user = User { name: String::from("a"), email: String::from("b") }
```

**Field shorthand** — when variable name matches field name

**Struct update** — `User { email, ..other }` copies remaining fields

**Tuple struct** — named tuple: `struct Color(i32, i32, i32)`

**Unit struct** — no fields: `struct AlwaysEqual;`

**Behavior** — free functions taking struct reference per conventions (no `impl` methods)

### 6.1 — Enums

**Enum definition** — type with variants
```
enum IpAddr { V4, V6 }
```

**Enum with data** — variants carry values
```
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}
```

**Option\<T\>** — enum for optional values
- `Some(T)` — value present
- `None` — no value
- Safer than null pointers

### 6.2 — match

Exhaustive pattern matching
```
match value {
    Pattern1 => result1,
    Pattern2 => result2,
    _ => default,
}
```

### 6.3 — if let

Concise match for one pattern
```
if let Some(value) = option {
    println!("{value}");
}
```

## Fixtures

| File | Topic |
|------|-------|
| `fixtures/03-structs.rs` | Struct def, init, update, tuple struct, free functions |
| `fixtures/03-enums.rs` | Enum, Option, match, if let |
