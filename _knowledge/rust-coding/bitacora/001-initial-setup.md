# 001 — Initial setup and modules 1-9

date: 2026-07-29

## Session overview

Established `_knowledge/rust-coding/` directory structure and worked through Rust Book chapters 1-9.

## Directory structure created

```
_knowledge/rust-coding/
├── precept/      — action-domain rule files
├── note/         — project aspect documentation
├── bitacora/     — session walkthroughs (this file)
├── glossary/     — atomic term definitions
├── reference/    — conventions and exceptions
├── fixtures/     — raw learning code
├── docs/         — (empty)
├── practice/     — (empty)
└── schemas/      — (empty)
```

## Precedence chain established

`precept/` → `note/` → `bitacora/` → `glossary/` → `reference/` → `fixtures/`

Each layer precedes the next. Rules govern all work. Conventions govern code.

## Fixtures completed (9 files)

| File | Chapter | Topic |
|------|---------|-------|
| ch01-hello.rs | ch1 | Hello world, println! |
| ch03-vars.rs | ch3 | Variables, types, mutability |
| ch03-control.rs | ch3 | Functions, if, loop, while, for |
| ch04-ownership.rs | ch4 | Move, clone, copy, ownership |
| ch04-references.rs | ch4 | & and &mut, borrowing |
| ch04-slices.rs | ch4 | String slices, array slices |
| ch05-structs.rs | ch5 | Structs, free functions |
| ch06-enums.rs | ch6 | Enums, Option, match, if let |
| ch07-modules.rs | ch7 | Modules, pub, use, paths |
| ch08-collections.rs | ch8 | Vec, String, HashMap |
| ch09-errors.rs | ch9 | Result, ?, panic, unwrap |

## Key decisions

- Fixtures named `ch{number}-aspect.rs` with source/module/compile headers
- Functions use one-word concrete nouns, no methods on structs
- Constants PascalCase with dead_code lint allowed
- Glossary terms are atomic declarative statements
- Precept rules are action-domain.md format

## Glossary terms created (13 files)

ownership, move, clone, copy, reference, mutable-reference, slice, struct, enum, option, match, crate, package, module, visibility, use, vec, hashmap, string, panic, result

## Open edges

- ch10-20 fixtures remaining
- docs/, practice/, schemas/ directories empty
- No test harness for fixtures (all manually compiled)
