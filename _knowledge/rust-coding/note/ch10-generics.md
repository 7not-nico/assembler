# ch10 — Generics, Traits, Lifetimes

Source: https://doc.rust-lang.org/stable/book/ch10-00-generics.html

## Generic Data Types

Type parameter declared with `<T>` after function/struct/enum name.

```
fn largest<T>(list: &[T]) -> &T { ... }
struct Point<T> { x: T, y: T }
enum Option<T> { Some(T), None }
```

Multiple type params: `struct Point<T, U> { x: T, y: U }`.

Monomorphization: compiler generates concrete code for each type used.

## Traits

Define shared behavior across types. Similar to interfaces in other languages.

```
trait Summary {
    fn summarize(&self) -> String;
}
```

Implement trait on a type: `impl Summary for Article { fn summarize(&self) -> String { ... } }`.

Default implementations: provide body in trait definition, override in `impl`.

Trait bounds: constrain generic types. `fn notify<T: Summary>(item: &T) { ... }`.
Or with `where` clause: `fn notify<T>(item: &T) where T: Summary { ... }`.

`impl Trait` syntax for simple cases: `fn notify(item: &impl Summary) { ... }`.

Multiple bounds: `fn compare<T: Summary + Display>(a: &T, b: &T)`.

Returning types that implement traits: `fn returns() -> impl Summary { ... }`.

## Lifetimes

Ensure references are valid for as long as they're used.

Syntax: `'a` — lifetime parameter. `fn longest<'a>(x: &'a str, y: &'a str) -> &'a str`.

Lifetime annotation means: the returned reference lives as long as the shorter of x and y.

**Elision rules** (compiler infers lifetimes in common patterns):
1. Each parameter gets its own lifetime
2. If exactly one input lifetime, it's assigned to all output lifetimes
3. If `&self` parameter, its lifetime is assigned to all output lifetimes

Static lifetime: `'static` — lives entire program duration. String literals are `'static`.
