## Identity

- Ripgrep — a line-oriented search tool; Andrew Gallant (BurntSushi) builds it in Rust, with the first release in 2016
- The name combines "rip" — meaning fast — with "grep" to signal its speed

## Function

- Ripgrep recursively searches the current directory for a regex pattern
- It respects `.gitignore`, `.ignore`, and `.rgignore` rules by default
- It supports PCRE2 via `-P`, smart case via `-S`, and JSON output via `--json`
- It skips hidden and binary files automatically

## Usage

- Developers run `rg pattern` for fast search
- Scripts read `--json` output for programmatic work
- Flags such as `-t py` or `-C 3` scope the search

## Design

- Ripgrep builds on Rust's `regex` engine, which uses finite automata and SIMD
- Parallel directory traversal places it among the fastest search tools

## Ecosystem

- VS Code embeds ripgrep as its default search engine
- It carries the Unlicense and MIT licenses

---
id: CLI.RIPGREP
title: Ripgrep
type: external
source: COG.COMPUTER.SCIENCE
precedes: []
tags: ripgrep, rg, regex, search, grep, rust, cli, tool
reference:
  - title: "Ripgrep — GitHub Repository"
    url: https://github.com/BurntSushi/ripgrep
  - title: "Ripgrep — Official Documentation"
    url: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
  - title: "Ripgrep — Manual Page"
    url: https://man.archlinux.org/man/extra/ripgrep/rg.1.en
---
