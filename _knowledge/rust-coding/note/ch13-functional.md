# ch13 — Iterators and Closures

Source: https://doc.rust-lang.org/stable/book/ch13-00-functional-features.html

## Closures

Anonymous functions that capture their environment. Syntax: `|params| body`.

```
let add = |a, b| a + b;
let add = |a, b| { a + b };
```

**Capture modes** — compiler infers the least permissive:
- `FnOnce` — takes ownership, can be called once
- `FnMut` — mutable borrow, can mutate captured values
- `Fn` — immutable borrow, can be called multiple times

**move keyword** — forces ownership transfer into closure: `let closure = move || println!("{x}");`

## Iterators

Lazy — no computation until consumed. The `Iterator` trait:
```
trait Iterator {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
}
```

**Consuming adaptors** — call `next()`, consume the iterator:
- `sum()`, `count()`, `collect()`, `for_each()`

**Iterator adaptors** — produce new iterators, lazy:
- `map()`, `filter()`, `take()`, `skip()`, `zip()`, `enumerate()`

**Ownership**: `iter()` — immutable refs, `iter_mut()` — mutable refs, `into_iter()` — owned values.
