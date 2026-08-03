## Identity

- Tracexec — a small tracer for `execve` and `execveat` calls and pre-exec behavior; the developer kxxt (Levi Zim) builds it in Rust, with the first release in October 2023
- The name combines "trace" — meaning to follow what runs — with "exec" to signal its focus

## Function

- Tracexec logs exec events with filename, argv, and environment diffs
- It offers three modes: `log` prints events, `tui` shows an interactive view, `collect` exports traces
- It exports traces as JSON, JSON-stream, or Perfetto format

## Usage

- Developers run `tracexec log -- cmd` to reveal what a command executes
- They export traces with `tracexec collect --format perfetto -o out.pftrace -- cmd`
- A TOML profile at `$XDG_CONFIG_HOME/tracexec/config.toml` sets fallback options

## Design

- A ptrace backend provides the default tracing
- An experimental eBPF backend (kernel 5.17+) supports system-wide tracing with less overhead

## Ecosystem

- The trace helps debug build systems and reveals what shell scripts do
- The tool launches gdb to debug programs run with piped stdio
- It draws inspiration from strace and lurk

---
id: CLI.TRACEXEC
title: Tracexec
type: external
source: COG.COMPUTER.SCIENCE
precedes: []
tags: tracexec, tracing, execve, ptrace, ebpf, debugger, rust, cli, tool
reference:
  - title: "Tracexec — GitHub Repository"
    url: https://github.com/kxxt/tracexec
  - title: "Tracexec — README"
    url: https://github.com/kxxt/tracexec/blob/main/README.md
  - title: "Tracexec — Docs.rs"
    url: https://docs.rs/crate/tracexec/latest
  - title: "Tracexec — Installation Guide"
    url: https://github.com/kxxt/tracexec/blob/main/INSTALL.md
---
