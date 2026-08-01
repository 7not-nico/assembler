# Rust Native Addon Plan

**Date**: 2026-07-24
**Priority**: P1 — plan before build
**Source**: `reports/notes/assembler-language-recommendation/`

## Architecture

```
.opencode/rust/
  Cargo.toml                    ← workspace root
  assembler-lib/                ← Rust lib crate: ports of _lib/ methods
    Cargo.toml                  ←   napi, napi-derive, rusqlite, serde
    src/
      lib.rs                    ←   re-exports all modules
      db.rs                     ←   initDB(), queryAll(), queryOne()
      entity.rs                 ←   getEntityTitle(), auditProtocolBody()
      embedder.rs               ←   embed(), embedBatch(), cosine() — ONNX runtime
      vector.rs                 ←   cosineSearch(), rrf()
      sync.rs                   ←   parsePatternFile(), syncAll()
    build.rs                    ←   napi_build::setup()
  assembler/                    ← napi-rs binary crate
    Cargo.toml
    src/lib.rs                  ← #[napi] exports mapping to assembler-lib
    package.json                ← napi config for binary name
```

Plugin wrapper at `.opencode/plugins/assembler-lib.ts`:

```ts
import { initDB, queryAll, embed, cosineSearch } from "../rust/assembler"

export const AssemblerLib = async function({ project, client, tool }) {
  return {
    tool: {
      "db.query": tool({
        description: "Query patlib database",
        args: { sql: tool.schema.string() },
        async execute({ sql }) {
          const db = initDB()
          return JSON.stringify(queryAll(db, sql))
        },
      }),
      // ... more tools mapped from assembler-lib exports
    },
  }
}
```

## Tasks

### Phase 1: Scaffold
- [ ] Install `@napi-rs/cli` in `.opencode/`
- [ ] `napi new` — scaffold `rust/assembler` with `@napi-rs/cli`
- [ ] Create `rust/Cargo.toml` workspace with `assembler-lib` + `assembler`
- [ ] Set `crate-type = ["cdylib"]` in `assembler/Cargo.toml`

### Phase 2: Port db.ts (first lib — foundation)
- [ ] Create `rust/assembler-lib/src/db.rs` — `initDB()`, `queryAll()`, `queryOne()` via rusqlite
- [ ] Use `bundled` feature for SQLite (no system dep)
- [ ] Create `rust/assembler/src/lib.rs` — `#[napi]` exports wrapping assembler-lib calls
- [ ] Build: `napi build --release`
- [ ] Test: `import { initDB } from "../rust/assembler"` from a TS tool
- [ ] Verify: same results as `import { initDB } from "../_lib/db.ts"`

### Phase 3: Port vector search (compute-heavy — highest value)
- [ ] Create `rust/assembler-lib/src/vector.rs` — cosineSearch, rrf, FTS5 queries
- [ ] Create `rust/assembler-lib/src/embedder.rs` — ONNX runtime binding via `ort` or `tract`
- [ ] Link embedder to napi-rs exports
- [ ] Benchmark: warm query latency (target: <2ms vs current 5.2ms)

### Phase 4: Port sync.ts (most complex — 706 LOC)
- [ ] Create `rust/assembler-lib/src/sync.rs` — frontmatter parsing, file scanning, entity sync
- [ ] Use `serde_yaml` + `pulldown-cmark` for body parsing
- [ ] Test: `syncAll()` produces identical DB as TS version

### Phase 5: Plugin wrapper
- [ ] Create `.opencode/plugins/assembler-lib.ts`
- [ ] Map all `#[napi]` exports to plugin tools
- [ ] Remove tool imports from `_lib/` — replace with `assembler` imports
- [ ] Verify: all existing tools work with native addon

## Build & CI

```bash
cd .opencode/rust
napi build --release        # produces .opencode/rust/assembler.{platform}.node
npm test                     # verify basic imports
```

## Verification

| Test | Expected |
|------|----------|
| `import { initDB } from "../rust/assembler"` | Works in Bun |
| `initDB().query("SELECT count(*) FROM patterns")` | Same count as bun:sqlite |
| Warm query latency | <2ms (vs current 5.2ms TS) |
| Binary size | Under 20MB (vs 50-100MB Bun compile) |
| All tools functional | No regression from _lib/ imports |
