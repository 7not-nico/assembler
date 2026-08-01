# Errors and Conclusions

**Date**: 2026-07-24
**Session**: Language recommendation, architecture mapping, vector search revival

## Errors Found

| # | Error | Severity | Status | Resolution |
|---|-------|----------|--------|------------|
| 1 | `mcp-patlib-vector` disabled in opencode.json | P0 | Open | Set `enabled: true` |
| 2 | 5 vector tools in `_disabled/` (506 LOC) | P0 | Open | Move to `tools/` |
| 3 | Vector hit rate 6% (FTS5 alone = 69%) | P2 | Open | Fine-tune bge-small |
| 4 | MCP server had ONNX inline → crash blocked all vector search | P0 | Solved by design | Rust lib handles errors |
| 5 | Bun dependency management unreliable (trump-voices evidence) | P1 | Open | Move lib deps to Cargo |
| 6 | Tools import `_lib/` with heavy deps → crash propagation risk | P1 | Open | Switch to `assembler-native` |
| 7 | No napi-rs build toolchain in project | P1 | Open | Add `@napi-rs/cli` |
| 8 | No Rust workspace in assembler | P1 | Open | Create `rust/` |

## Decisions Made

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | **Rust (napi-rs) for functional core** | Cargo deps reliable. Error handling by Result. Single binary. |
| D2 | **Bun for imperative shell** | MAX.BUN.ONLY. Tools are thin (19 LOC avg). OpenCode runtime API is TS. |
| D3 | **One monolithic `.node` binary** | Every tool imports 2-5 libs. High overlap. LTO strips unused. |
| D4 | **Plugin wrapper registers tools** | Persistent. In-process. Zero IPC. Follows existing plugin pattern. |
| D5 | **Stdio transport for MCP** | Drop-in replacement. No port management. Same protocol. |
| D6 | **Revive vector search first (P0)** | 506 LOC proven code. Immediate value. Proves the move path. |

## Mapping to Existing Entities

| Entity | Role in Decision |
|--------|-----------------|
| MAX.BUN.ONLY | Tools = Bun. Libs = Rust (new: lib exception). |
| MAX.CODE.LAYERS | 7 rings: Rust = PURE ring. Bun = outer rings. 5 classes: tools declare class. |
| MAX.ENTITY.ONTOLOGY | Rust = functional core. Bun = imperative shell. |
| MAX.DRY | One binary holds all deps. No duplicate logic. |
| MAX.PROGRAMMING.DELIBERATELY | Research done before code. Reports written first. |
| PROT.MCP.TRANSPORT | MCP servers stay stdio. Rust binary uses rust-sdk stdio. |
| PROT.TOOL.HOOKS | Plugin registers tools via `tool:` hook. |
| PROT.TOOL.STRUCTURE | Plugin file at `plugins/assembler-lib.ts`. |
| PROT.TOOL.RUNNER | Rust binary: no runner needed. Single file. |

## Timestamps

| Event | UTC |
|-------|-----|
| Session start | 2026-07-24 |
| Patlib guidance analyzed | 2026-07-24 |
| MCP benchmark data collected | 2026-07-24 |
| trump-voices tromp pattern documented | 2026-07-24 |
| _lib/ import audit completed | 2026-07-24 |
| napi-rs research completed | 2026-07-24 |
| Vector search inventory completed | 2026-07-24 |
| Bun dep failure documented | 2026-07-24 |
| Architecture mapping finalized | 2026-07-24 |
| All reports written | 2026-07-24 |
| All todos created | 2026-07-24 |
