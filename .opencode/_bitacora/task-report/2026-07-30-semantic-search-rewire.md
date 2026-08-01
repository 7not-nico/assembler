# Task Report — Semantic Search CLI Rewired In-Process

Timestamp: 2026-07-30
Project: root assembler
Task: re-enable `semantic-search` CLI query without Rust-pipe spawn lock

## What was done

1. **State confirmed** — `semantic-search.ts` (CLI) and `search-semantic.ts` (IPC) sat in `tools/_disabled/`. Both spawned `_rustlib/target/release/assemble` (`Bin`) over stdin/stdout; that spawn path locked opencode (AGENTS.md record).
2. **Rewired CLI** — rewrote `.opencode/tools/semantic-search.ts` to use in-process `_lib/score.ts`:
   - `hit(query, vecList, k)` replaces Rust `hit` verb (JSON over pipe → `Bun.spawn` removed).
   - `vecList` built as `Float32Array[]` directly from stored BLOBs — `Array.from` copies dropped.
   - Removed `Bin` import from `_lib/paths`.
3. **Re-enabled** — deleted `tools/_disabled/semantic-search.ts`; live tool now at `tools/semantic-search.ts`.
4. **Verified** — query `"entity derivation precedence"` `--k 5` returns 5 ranked matches over 584 indexed embeddings; top hit `PRE.PRECEDENCE.DERIVATION.CHAIN` at 0.7738. Titles joined from `patlib.db`.

## Decisions made

- In-process cosine over Rust ANN — pure `_lib/score.ts` mirrors `r0-vector.rs` semantics (per AGENTS.md rewire directive); no spawn, no lock.
- CLI re-enabled; IPC `search-semantic.ts` left in `_disabled/` — out of scope, same rewire applies when needed.

## Follow-up (append)

- IPC variant `search-semantic.ts` removed from `_disabled/` — semantic search is CLI-only per user direction. AGENTS.md updated: search tool line now records CLI-only, in-process, no Rust spawn.

## Todo state summary

- [x] Rewire semantic-search CLI to `_lib/score.ts` in-process
- [x] Re-enable from `_disabled/`
- [x] Verify query + title join
- [x] Write report
