# Execution Phases — Rust Native Addon + Vector Search Revival

**Date**: 2026-07-24
**Source**: `reports/notes/assembler-language-recommendation/execution-plan.md`

## Track A — Vector Search Revival (P0 — 30 min)

- [ ] A1: `opencode.json` line 36 — set `"enabled": true`
- [ ] A2: `mv .opencode/tools/_disabled/mcp-patlib-vector .opencode/tools/mcp-patlib-vector`
- [ ] A3: `mv .opencode/tools/_disabled/search-vectors.ts .opencode/tools/search-vectors.ts`
- [ ] A3b: `mv .opencode/tools/_disabled/reindex-vectors.ts .opencode/tools/reindex-vectors.ts`
- [ ] A3c: `mv .opencode/tools/_disabled/similar-vectors.ts .opencode/tools/similar-vectors.ts`
- [ ] A3d: `mv .opencode/tools/_disabled/bench-vectors.ts .opencode/tools/bench-vectors.ts`
- [ ] A4: verify import paths — `mcp-patlib-vector/index.ts` uses `../../_lib/` (was correct at _disabled depth)
- [ ] A5: test `patlib_vector_search --query "knowledge classification" --mode hybrid`
- [ ] A6: test `patlib_vector_reindex`
- [ ] A7: test `patlib_vector_similar --entity-id MAX.DRY`
- [ ] A8: run `bun run bench-vectors.ts --full --report` → save to reports

## Track B — Rust Native Addon

### P1 — Scaffold (1 hour)

- [ ] P1.1: `bun add @napi-rs/cli` in `.opencode/`
- [ ] P1.2: `mkdir -p .opencode/rust`
- [ ] P1.3: Create `rust/Cargo.toml` workspace (members: assembler-lib, assembler)
- [ ] P1.4: Scaffold `rust/assembler-lib/` — Cargo.toml, build.rs, src/lib.rs
- [ ] P1.5: Scaffold `rust/assembler/` — Cargo.toml, build.rs, src/lib.rs, package.json
- [ ] P1.6: `napi build --release` — verify `.node` file produced
- [ ] P1.7: Test `const x = require("../rust/assembler")` in Bun

### P2 — Port db.ts (4 hours)

- [ ] P2.1: `rust/assembler-lib/src/db.rs` — initDB, queryAll, queryOne with rusqlite bundled
- [ ] P2.2: Export via `#[napi]` in `rust/assembler/src/lib.rs`
- [ ] P2.3: Build + test — same results as TS `_lib/db.ts`

### P3 — Port vector search (8-16 hours)

- [ ] P3.1: `rust/assembler-lib/src/embedder.rs` — ONNX via ort/tract
- [ ] P3.2: `rust/assembler-lib/src/vector.rs` — cosineSearch, rrf, FTS5 queries
- [ ] P3.3: Export via `#[napi]`
- [ ] P3.4: Benchmark — target <2ms warm query (vs 5.2ms TS)

### P4 — Plugin wrapper (2 hours)

- [ ] P4.1: Create `plugins/assembler-lib.ts`
- [ ] P4.2: Register tools via `tool:` hook
- [ ] P4.3: Replace `_lib/` imports in tools with `assembler-native`

### P5 — Dependency audit (1 hour)

- [ ] P5.1: Audit all `package.json` in `.opencode/`
- [ ] P5.2: Run `verify-deps` tool
- [ ] P5.3: Document Bun dep failure pattern

## Verification

- [ ] All 16 bench queries return expected results
- [ ] Warm query <2ms
- [ ] No tool imports from `_lib/` for lib logic
- [ ] MCP crash does not affect other tools
- [ ] `bun install` completes in <5s
