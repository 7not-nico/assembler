# ch7 — Packages, Crates, Modules

Source: https://doc.rust-lang.org/stable/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html

## Key Concepts

**Crate** — compilation unit. Binary (main.rs) or Library (lib.rs).

**Package** — Cargo.toml bundle. One or more crates.

**Module** — namespace within a crate. `mod` keyword. Inline or separate file.

**Visibility** — private by default. `pub` makes public. `pub(crate)` for crate-scoped.

**Paths** — absolute (`crate::module::Item`) or relative (`self::`, `super::`).

**use** — brings items into scope. `use crate::module::Item`. `as` for aliasing.

## Fixture

`fixtures/ch07-modules.rs` — inline modules, pub, use, paths, super/self
