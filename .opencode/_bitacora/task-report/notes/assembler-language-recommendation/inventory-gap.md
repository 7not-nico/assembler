# Assembler Inventory — What's Present vs What's Missing

**Date**: 2026-07-24

## Present — Active Components

### Tools (18 active)
- 23 tool entries in `.opencode/tools/`, 18 active, 5 disabled
- 7 Custom IPC tools, 6 MCP servers, 5 disabled
- All import from `_lib/` (shared libs)

### MCP Servers (8 active, 1 disabled)

| Server | Type | Status |
|--------|------|--------|
| mcp-patlib | local, stdio | ✅ active |
| mcp-patlib-vector | local, stdio | ❌ **disabled** |
| mcp-spec-audit | local, stdio | ✅ active |
| mcp-entity-audit | local, stdio | ✅ active |
| mcp-burst-alert | local, stdio | ✅ active |
| mcp-compartment-audit | local, stdio | ✅ active |
| mcp-arxiv | findings/ subproject | ✅ active |
| mcp-biorxiv | findings/ subproject | ✅ active |
| mcp-findings | findings/ subproject | ✅ active |

### Shared Libs (43 files in `_lib/`)

Core libs: `db.ts`, `sync.ts`, `paths.ts`, `parse.ts`, `errors.ts`
Vector libs: `vector-db.ts`, `vector-query.ts`, `vector-queries.ts`, `rank.ts`, `reindex-entity.ts`, `entity-paths.ts`, `embedder.ts`, `embedder-onnx.ts`, `vector-bench.ts`, `ensure-vector-schema.ts`
Entity libs: `entity-audit.ts`, `entity-format.ts`, `entity-lookup.ts`, `entity-paths.ts`, `entity-text.ts`, `read-entities.ts`, `reindex-entity.ts`
Other: `mcp-types.ts`, `mcp-query.ts`, `mcp-format.ts`, `spec-*` (4), `arxiv-*` (3), `audit-*` (3), `compartment-*` (3), `validate-*` (5)

### Reports (49 files in `.opencode/reports/`)
- Vector search: `vector-search-monolith-extraction.md`, `vector-search-improvements.md`, `vector-search-performance.md`
- Architecture: `subproject-map.md`, `system-health.md`, `mcp-server-inventory.md`
- Audits: `tool-audit-compliance.md`, `maxim-violations-current-state.md`, `protocol-audit.md`
- Vector-specific: 8 reports covering performance, improvements, monolith extraction

## Missing — Disabled or Unavailable

### 1. Vector Search (fully coded, disabled)

5 complete tools sitting in `_disabled/`:
- `mcp-patlib-vector` — MCP server (221 LOC, 4 tools)
- `search-vectors.ts` — CLI search (96 LOC)
- `reindex-vectors.ts` — CLI reindex (42 LOC)  
- `similar-vectors.ts` — CLI similar (70 LOC)
- `bench-vectors.ts` — CLI benchmark (77 LOC)

**506 lines of proven, tested code disabled.** Existing `opencode.json` entry set to `enabled: false`.

### 2. Rust Native Addon (not started)

No Rust code in root project. `trump-voices/` has Rust (`tromp`) but assembler doesn't.
- Goal: compile `_lib/` → Rust → napi-rs `.node` binary
- Plugin wrapper to register tools
- One binary holding all deps

### 3. Accuracy Optimization (identified, not executed)

- Vector hit rate at 6% — fine-tuning bge-small could push to 30-50%
- Fine-tuning pipeline not started
- Cross-encoder reranking not implemented

## Gap Analysis

| Priority | Gap | Impact | Effort |
|----------|-----|--------|--------|
| P0 | Vector search disabled | No semantic search in runtime | **Minutes** — flip `enabled: true` |
| P1 | No Rust binary | Need to plan native addon crate layout | Days |
| P2 | Vector accuracy low | Hybrid RRF = FTS5 alone (no gain) | Weeks |
| P3 | No fine-tuning pipeline | Biggest accuracy lever untouched | Weeks |
