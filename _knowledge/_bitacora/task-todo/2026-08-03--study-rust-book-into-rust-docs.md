# study rust book into rust-docs — day 2

Status: in progress (2026-08-03)

## Tasks

- [ ] ch05 Using Structs to Structure Related Data (concepts + fixture)
- [ ] ch06 Enums and Pattern Matching
- [ ] ch07 Managing Growing Projects with Packages, Crates, and Modules
- [ ] ch08 Common Collections
- [ ] ch09 Error Handling
- [ ] ch10 Generic Types, Traits, and Lifetimes
- [ ] ch11 Writing Automated Tests
- [ ] ch12 An I/O Project: Building a Command Line Program
- [ ] ch13 Functional Language Features: Iterators and Closures
- [ ] ch14 More about Cargo and Crates.io
- [ ] ch15 Smart Pointers
- [ ] ch16 Fearless Concurrency
- [ ] ch17 Object Oriented Programming Features of Rust
- [ ] ch18 Patterns and Matching
- [ ] ch19 Advanced Features
- [ ] ch20 Final Project: Building a Multithreaded Web Server
- [ ] ch21 Appendix (A-Z, useful dev tools, edition guide)
- [ ] Distill reference/ from concept/ claims
- [ ] Write session report (knowledge bitacora close)

## Carry-over context

- Book: https://doc.rust-lang.org/book/ (edition 2024, Rust 1.90+)
- Toolchain: rustc 1.97.1; fixtures compile `rustc --edition 2021`
- Chain: precept/ → concept/ → reference/ → fixture/; script/ parallel
- Day 1 done: ch01–ch04 [x]; 55 concept files; 4 fixtures (hello-world, guessing-game, fibonacci, slices) all compile + run
- Per-chapter loop: navigate chNN section pages via Playwright, snapshot, file one concept per idea (write-every-concept), write + compile fixture (compile-every-fixture), mark [x]
- Log every command through `bash _knowledge/_bitacora/bitacora-log.sh {name} -- {cmd}` → task-stdout/
- Session report lands in `_knowledge/_bitacora/task-report/`; close via bitacora-close.sh
