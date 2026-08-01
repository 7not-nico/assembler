# ch14 — Cargo and Crates.io

Source: https://doc.rust-lang.org/stable/book/ch14-00-more-about-cargo.html

## Release profiles

`[profile.dev]` and `[profile.release]` in Cargo.toml. Customize `opt-level`, `debug`, etc.

## Documentation

`///` — doc comments, generate HTML docs via `cargo doc`. `//!` — inner doc comments (crate/module level).

Doc tests: code blocks in doc comments run as tests via `cargo test`.

`#[doc(cfg(...))]` — show which features enable an item.

## Publishing

`cargo publish` — upload to crates.io. Requires `[package]` fields: name, version, edition, description, license.

`cargo yank` — prevent new projects from using a version.

## Workspaces

Multiple crates sharing one Cargo.lock. Root Cargo.toml defines `[workspace]` members.

## Features

`[features]` in Cargo.toml. `#[cfg(feature = "feature_name")]` for conditional compilation.

`cargo install` — install binary crates from crates.io.
