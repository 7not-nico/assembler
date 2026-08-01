# Imperative Shell / Functional Core Boundary

**Date**: 2026-07-24
**Reference**: MAX.ENTITY.ONTOLOGY

## The Split

```
Functional Core (Rust)           Imperative Shell (Bun)
─────────────────────           ────────────────────────
assembler-lib                    plugins/assembler-lib.ts
  db.rs → initDB, queryAll        tool: "db.query" → calls Rust
  vector.rs → cosine, rrf         tool: "patlib_vector_search"
  embedder.rs → embed, embedBatch tool: "patlib_vector_reindex"
  sync.rs → parse, syncAll        tool: "write-sync"
                                 tools/*.ts (all existing tools)
```

## Why This Split Solves the Crash Problem

**Before**: MCP server imported ONNX → ONNX crashed → MCP server crashed → no vector search for anyone.

**After**: Rust lib has ONNX → ONNX error → Rust returns `Result::Err` → Bun formats as tool error message → no crash.

```
Before:
  Tool → imports _lib/embedder-onnx → ONNX WASM → crash → process dies

After:
  Tool → calls Rust #[napi] fn → ONNX via ort/tract → Result<T,E> → Bun gets error string
```

## Error Flow

```
Rust function error
  → Err("model not loaded")
  → napi-rs converts to JS Error
  → Bun tool catches and formats
  → User sees: { error: "model not loaded" }
  → Process stays alive
  → Other tools still work
```

No crash propagation. No blocked workers.

## Dependency Management

| Aspect | Bun (TS) | Cargo (Rust) |
|--------|----------|--------------|
| Resolution | `bun install` — unreliable per trump-voices | `cargo build` — deterministic |
| Lock file | `bun.lock` — known issues | `Cargo.lock` — stable |
| Native deps | ONNX via npm → slow/brittle | ONNX via crates.io → `ort` crate |
| SQLite | `bun:sqlite` (built-in) | `rusqlite` (bundled feature) |
| Binary | 50-100MB (Bun compile) | 5-20MB (.node file) |
| Runtime deps | node_modules/ | None (single .node file) |

## The trump-voices Precedent

trump-voices has the exact same split working in production:

| Layer | trump-voices | Assembler |
|-------|-------------|-----------|
| Functional Core | Rust `tromp-lib` (paths, db, audio) | Rust `assembler-lib` (db, vector, embedder) |
| Binary | Rust `tromp` (clap CLI) | Rust `assembler` (napi-rs addon) |
| Shell | TS tools (acquire, chunk, search) | TS tools (read, write, audit) |
| Fallback | Ruby launcher (if no Rust binary) | TS _lib/ (during transition) |

## Verification

After implementation:
- [ ] Rust lib exports all methods as `#[napi]` functions
- [ ] Bun plugin imports `.node` binary
- [ ] Every tool that previously imported `_lib/` now imports `assembler-native`
- [ ] ONNX error returns tool message, not crash
- [ ] Warm query <2ms
