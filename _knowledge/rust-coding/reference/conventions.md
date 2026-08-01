# Rust Coding Conventions

Applied to all Rust code in this repository.

## Naming

Struct — one word, singular abstract noun, Upper. No abbreviations.
- `Hit`, `Point`, `Store`

Function — one word, singular concrete noun, lower. Describes what it produces.
- `score`, `norm`, `unit`

Method — two words, camelCase, action verb. Verb + noun.
- `computeScore`, `makeUnit`, `findIndex`

Variable — one word, singular descriptive, lower. Declared at file top. No verbs.
- `count`, `value`, `query`

Constant — one word, PascalCase. No verbs, no underscores.
- `MaxPoints`, `ThreeHours`

File — one word, kebab-case. Ring prefix when inside `_rustlib/src/`.
- `r0-vector.rs`, `r0-index.rs`

## Prohibitions

Gerunds — `computing`, `storing`, `running`. Nominalized action. Use concrete noun instead.

Nominalizations — `computation`, `storage`, `execution`. Derived noun. Use verb or concrete noun.

Methods on structs — `impl Point { fn distance(&self) }`. Replace with free function: `fn distance(a: &Point, b: &Point)`.

Redundant naming — `score_value`, `hit_result`, `vector_arr`. `score`, `hit`, `arr` sufficient.

Underscore prefix — `_count`, `_temp`, `_unused`. Use `let _ = expr` (bare underscore pattern) for compiler warning suppression. No `_name` form.

## Exceptions

Source: https://doc.rust-lang.org/stable/reference/keywords.html

Rust keywords cannot be used as identifiers (variable, function, struct, field, variant, type parameter, lifetime, macro, attribute, crate names).

### Strict keywords (all editions)

`_` `as` `async` `await` `break` `const` `continue` `crate` `dyn` `else` `enum` `extern` `false` `fn` `for` `if` `impl` `in` `let` `loop` `match` `mod` `move` `mut` `pub` `ref` `return` `self` `Self` `static` `struct` `super` `trait` `true` `type` `unsafe` `use` `where` `while`

### Reserved keywords (future use)

`abstract` `become` `box` `do` `final` `gen` `macro` `override` `priv` `try` `typeof` `unsized` `virtual` `yield`

### Weak keywords (context-dependent)

`'static` `macro_rules` `raw` `safe` `union`

### Lint overrides

Rust lint conventions override project naming when they enforce compiler warnings. Suppress unavoidable lints with `#[allow(LintName)]` on the item. Example: `#[allow(non_upper_case_globals)]` for PascalCase constants.

## Structure

Atomic — one function does one thing. No side effects.

Inlined methods — free functions replace `impl` blocks. No method calls — direct function calls.

No classes — Rust structs hold data only. Behavior in free functions.

No traits — trait objects and generics reserved for Module 5+.

## Ring topology

R0 — PURE. stdin/stdout only at CLI boundary. Pure functions, no side effects.

R1 — I/O. Filesystem, database. Addressed in Module 4+.

Functional core in `_rustlib/src/`. CLI shell in `main.rs`.

## Precedence

Pure functions over stateful.

Composition over inheritance (no inheritance at all).

Explicit over implicit (annotate types at public boundaries).

Expression over statement (return last expression, not `return`).

Immutable over mutable (`let` over `let mut` unless mutation required).

## Semantic code conventions

Redundancies eliminated. Code is atomic. One function does one thing. No duplication.

Methods inlined. Free functions replace `impl` blocks.

Variable must differ from function name. No shadowing.

Concrete noun is a physical, sensorily-perceivable entity.

Abstract noun is a concept, quality, state, or relation.

## Reference

See `reference/element-name.md` for full noun classification, agentive suffix rules, and shadowing prevention.
