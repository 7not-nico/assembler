# ch11 — Writing Automated Tests

Source: https://doc.rust-lang.org/stable/book/ch11-00-testing.html

## Test attributes

`#[test]` — marks a function as a test. `cargo test` runs all tests in a crate.

`#[should_panic]` — test passes if code panics.

`#[ignore]` — skip test during normal run. Run with `cargo test -- --ignored`.

## Assertions

`assert!(expr)` — panics if expression is false.

`assert_eq!(a, b)` — panics if a != b. Requires PartialEq + Debug.

`assert_ne!(a, b)` — panics if a == b.

Custom messages: `assert!(expr, "message: {}", value)`.

## Test organization

**Unit tests** — in same file as code, `#[cfg(test)]` module. Test private functions.

**Integration tests** — in `tests/` directory. Each file is a separate crate. Only test public API.
