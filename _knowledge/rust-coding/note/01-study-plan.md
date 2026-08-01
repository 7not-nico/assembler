# Rust Study Plan

**Source** — [doc.rust-lang.org/stable/](https://doc.rust-lang.org/stable/)
**Primary** — [The Rust Programming Language (The Book)](https://doc.rust-lang.org/book/)
**Secondary** — [Rust by Example](https://doc.rust-lang.org/stable/rust-by-example/)
**Reference** — [std docs](https://doc.rust-lang.org/stable/std/), [Rustonomicon](https://doc.rust-lang.org/nomicon/)

## Principles

- **Pocock** — structured progression, each step builds on prior. Directed (Book chapters) + undirected (topic exploration).
- **Mallat** — theory→code unified. Every concept has a fixture file. No jumps — fill gaps before advancing.
- **Sakana** — biggest risk first. Ownership/borrowing in Module 2 (week 1), not postponed.

## Curriculum

| Module | Book Chapters | Topic | Fixtures |
|--------|--------------|-------|----------|
| 1 | ch1-3 | Toolchain, types, variables, control flow, functions | `fixtures/01-hello/`, `fixtures/01-vars/`, `fixtures/01-control/` |
| 2 | ch4 | Ownership, references, borrowing, slices | `fixtures/02-ownership/`, `fixtures/02-references/`, `fixtures/02-slices/` |
| 3 | ch5-6 | Structs, enums, pattern matching, `Option`, `Result` | `fixtures/03-structs/`, `fixtures/03-enums/`, `fixtures/03-match/` |
| 4 | ch7-9 | Modules, collections (Vec, HashMap), error handling | `fixtures/04-modules/`, `fixtures/04-collections/`, `fixtures/04-errors/` |
| 5 | ch10 | Generics, traits, lifetimes | `fixtures/05-generics/`, `fixtures/05-traits/`, `fixtures/05-lifetimes/` |
| 6 | ch11-12 | Tests, CLI programs, I/O | `fixtures/06-tests/`, `fixtures/06-cli/` |
| 7 | ch13-15 | Iterators, closures, smart pointers, `Box`, `Rc`, `RefCell` | `fixtures/07-iterators/`, `fixtures/07-closures/`, `fixtures/07-smart/` |
| 8 | ch16-17 | Concurrency, `Send`/`Sync`, `Arc`, `Mutex`, async basics | `fixtures/08-concurrency/` |
| 9 | ch19-20 | Unsafe Rust, FFI, `unsafe` blocks, raw pointers | `fixtures/09-unsafe/` |
| 10 | — | Applied: assemble-core functional core patterns | `_rustlib/` refactor review |

## Workflow

1. Read chapter from The Book
2. Create note in `note/{module}-{topic}.md`
3. Create fixture code in `fixtures/{module}-{topic}/main.rs`
4. `rustc fixtures/{path}/main.rs && ./main` to verify
5. Reference schemas in `schemas/` if DB tracking needed

## Directory layout

```
_knowledge/rust-coding/
├── docs/          — fetched documentation excerpts
├── fixtures/      — compilable Rust code examples
├── note/          — personal study notes
├── practice/      — exercise scaffolding
├── reference/     — lookup tables, cheat sheets
└── schemas/       — DB schemas for knowledge tracking
```
