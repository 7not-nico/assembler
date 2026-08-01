# ch12 — I/O Project: CLI tool

Source: https://doc.rust-lang.org/stable/book/ch12-00-an-io-project.html

## Command line arguments

`std::env::args()` — returns iterator of command line arguments. First arg is program path.

## File reading

`std::fs::read_to_string(path)` — reads file into String. Returns `Result<String, io::Error>`.

## Architecture pattern

Separate concerns: binary crate handles CLI, library crate handles logic.

**Binary** (`main.rs`): parse args, call library, handle errors.

**Library** (`lib.rs`): `Config` struct, `search` / `search_case_insensitive` functions.

## TDD for search

Write test first, then implement:
```
#[test]
fn case_sensitive() {
    let query = "duct";
    let contents = "Rust:\nsafe, fast, productive.";
    assert_eq!(vec!["safe, fast, productive."], search(query, contents));
}
```

## Environment variables

`std::env::var("IGNORE_CASE")` — returns `Result<String, VarError>`.

## Stderr vs stdout

`eprintln!()` — writes to stderr. `println!()` — writes to stdout.

Use stderr for errors, diagnostics. Use stdout for program output only.
