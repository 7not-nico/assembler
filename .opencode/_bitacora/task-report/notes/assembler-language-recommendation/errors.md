# Errors & Conclusions — Language Recommendation

**Date**: 2026-07-24

## Errors / Gaps Found

| # | Error | Status | Resolution |
|---|-------|--------|------------|
| 1 | `mcp-patlib-vector` disabled in `opencode.json` | Open | Set `"enabled": true` |
| 2 | 5 vector tools in `_disabled/` — 506 LOC unused | Open | Move to `.opencode/tools/` |
| 3 | Vector hit rate 6% — FTS5 carries the system (69%) | Open | Fine-tune bge-small on entity data |
| 4 | No Rust code in assembler (trump-voices has it) | Open | Scaffold napi-rs workspace |
| 5 | No napi-rs build toolchain in `.opencode/package.json` | Open | Add `@napi-rs/cli` dep |
| 6 | No plugin wrapper for native addon | Open | Create `plugins/assembler-lib.ts` |
| 7 | Existing reports in `.opencode/reports/` vs new in `reports/notes/` — two report locations | Note | Standardize on `reports/notes/` |

## Conclusions

| Topic | Conclusion |
|-------|-----------|
| **Language choice** | TypeScript/Bun for tools. Rust (napi-rs) for libs. One binary holding all deps. |
| **Why not Go** | Break MAX.BUN.ONLY. Complete rewrite. No `tromp` precedent. |
| **Why not Rust for everything** | Tools are thin wrappers (19 LOC avg). No benefit. |
| **Why napi-rs** | In-process, zero IPC overhead (~50ns crossing). Bun's recommended native path. |
| **Monolithic binary** | Every tool imports 2-5 libs. High overlap. One binary serves all with LTO stripping unused. |
| **Plugin wrapper** | Loaded at runtime start. Persistent. No MCP protocol needed. Follows existing plugin pattern (8 existing). |
| **Vector search** | P0 gap. 506 LOC sitting disabled. 5.2ms warm queries. Ideal first Rust target. |

## Timestamps

| Event | Time |
|-------|------|
| Research start | 2026-07-24 |
| Patlib guidance analyzed | 2026-07-24 |
| MCP benchmark data collected | 2026-07-24 |
| trump-voices tromp pattern documented | 2026-07-24 |
| _lib/ import audit completed | 2026-07-24 |
| napi-rs research completed | 2026-07-24 |
| Vector search inventory completed | 2026-07-24 |
| Reports written | 2026-07-24 |
