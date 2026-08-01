# ch9 — Error Handling

Source: https://doc.rust-lang.org/stable/book/ch09-00-error-handling.html

## panic!

Unrecoverable error. Prints failure message, unwinds stack, quits.

```
panic!("crash and burn");
```

`RUST_BACKTRACE=1` environment variable shows full backtrace.

## Result<T, E>

Recoverable error. Enum with Ok(T) or Err(E).

```
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

**Matching** — handle both variants explicitly.

**unwrap()** — returns Ok value or panics on Err.

**expect(msg)** — same as unwrap but with custom panic message.

**? operator** — propagates Err to caller. Shorthand for match { Ok(v) => v, Err(e) => return Err(e) }.

**Chaining**: `fn read() -> Result<String, io::Error> { let mut f = File::open("foo")?; ... }`

**Converting errors**: `.map_err(|e| MyError::from(e))` or `impl From<io::Error> for MyError`.

## When to panic

Panic on: examples, test stubs, unrecoverable states, bad input from trusted sources.

Use Result for: expected failures, bad input from users, network errors, file I/O.
