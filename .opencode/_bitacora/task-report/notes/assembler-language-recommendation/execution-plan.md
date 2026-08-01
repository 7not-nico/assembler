# Execution Plan — Rust Lib Binary + Vector Search Revival

**Date**: 2026-07-24
**Status**: Final

## Overview

Two parallel tracks:

```
Track A: Vector Search Revival (P0 — hours)
  └── Flip enabled + move files + test

Track B: Rust Native Addon (P1-P5 — days/weeks)
  └── Scaffold → port db → port vector → plugin → switch imports
```

## Track A — Vector Search Revival

506 lines of proven, tested code sitting in `_disabled/`. Immediate fix.

| Step | Action | File |
|------|--------|------|
| A1 | Set `"enabled": true` in opencode.json line 36 | `opencode.json` |
| A2 | Move `mcp-patlib-vector/` to `.opencode/tools/` | `_disabled/` → `tools/` |
| A3 | Move 4 CLI tools to `.opencode/tools/` | `_disabled/` → `tools/` |
| A4 | Test `patlib_vector_search --mode hybrid` | MCP tool |
| A5 | Test `patlib_vector_reindex` | MCP tool |
| A6 | Run `bench-vectors.ts --full --report` | CLI tool |

## Track B — Rust Native Addon

### Phase P1: Scaffold

| Step | Action | Output |
|------|--------|--------|
| P1.1 | Install `@napi-rs/cli` | `.opencode/package.json` dep |
| P1.2 | Create `rust/` directory | `.opencode/rust/` |
| P1.3 | Create workspace `Cargo.toml` | `rust/Cargo.toml` |
| P1.4 | Scaffold `assembler-lib/` crate | `rust/assembler-lib/` |
| P1.5 | Scaffold `assembler/` binary crate | `rust/assembler/` |
| P1.6 | Build empty addon | `assembler.{platform}.node` |
| P1.7 | Verify `require("../rust/assembler")` works | Import test |

### Phase P2: Port db.ts

| Step | Action | Notes |
|------|--------|-------|
| P2.1 | Create `rust/assembler-lib/src/db.rs` | initDB, queryAll, queryOne |
| P2.2 | Use `rusqlite` with `bundled` feature | No system SQLite dep |
| P2.3 | Export via `#[napi]` in `assembler/` | Function signatures match TS |
| P2.4 | Build + test | Compare results with TS version |

### Phase P3: Port vector search

| Step | Action | Notes |
|------|--------|-------|
| P3.1 | Create `rust/assembler-lib/src/embedder.rs` | ONNX via `ort` or `tract` |
| P3.2 | Create `rust/assembler-lib/src/vector.rs` | cosineSearch, rrf, FTS5 |
| P3.3 | Benchmark | Target: <2ms warm query |
| P3.4 | Test | Compare accuracy with TS version |

### Phase P4: Plugin wrapper

| Step | Action | Notes |
|------|--------|-------|
| P4.1 | Create `plugins/assembler-lib.ts` | Thin wrapper, imports .node |
| P4.2 | Register tools via `tool:` hook | Maps `#[napi]` exports |
| P4.3 | Remove `_lib/` imports from tools | Replace with `assembler` import |

### Phase P5: Dependency audit

| Step | Action | Notes |
|------|--------|-------|
| P5.1 | Audit all `package.json` in `.opencode/` | Check resolution issues |
| P5.2 | Verify `node_modules` symlinks | `verify-deps` tool |
| P5.3 | Document Bun dep failure pattern | For reference |

## Timing

| Phase | Effort | Blocked By |
|-------|--------|------------|
| A (revive) | 30 minutes | Nothing |
| P1 (scaffold) | 1 hour | Nothing |
| P2 (port db) | 4 hours | P1 |
| P3 (port vector) | 8-16 hours | P2 |
| P4 (plugin) | 2 hours | P3 |
| P5 (audit) | 1 hour | Nothing |
