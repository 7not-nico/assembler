# mcp-semantic — MCP server for the semantic engine — session report

Date: 2026-08-02
Branch: main

## Work done

Built, verified, and registered an MCP server exposing the semantic engine workflow as agent tools, following the `propose-mcp` skill procedure (detect → check → design → write → verify).

## Deliverables

| File | Role |
|------|------|
| `.opencode/tools/mcp-semantic/index.ts` | Server — `McpServer({ name: "semantic" })`, 6 tools, stdio transport |
| `.opencode/tools/mcp-semantic/package.json` | Metadata (deps declared; resolved via shared symlink) |
| `.opencode/tools/mcp-semantic/tsconfig.json` | TS config |
| `.opencode/tools/mcp-semantic/node_modules` | Symlink → `../../node_modules` (`.opencode/node_modules`) |
| `.opencode/_lib/semantic-types.ts` (pure) | Shared interfaces |
| `.opencode/_lib/semantic-format.ts` (pure) | Response formatting |
| `.opencode/_lib/semantic-query.ts` (io) | DB/engine ops, reuses `_lib/embed|ann|paths` |

Tools: `semantic_search`, `semantic_stats`, `semantic_drift`, `semantic_embed`, `semantic_purge`, `semantic_eval` — every arg `.describe()`d; `z.enum()` with `as const`.

## Verification (stdio smoke test)

- `initialize` → serverInfo `semantic 1.0.0`, protocol 2024-11-05
- `tools/list` → 6 tools
- `tools/call`:
  - `semantic_stats` — per-table counts (illustrations 79, rules 79, skills 66, concepts 62…)
  - `semantic_drift` — 0 missing / 0 stale
  - `semantic_purge` — `0 stale embeddings found (dry-run)`
  - `semantic_search` "vector embedding nearest neighbor retrieval" — top hit `RUL.VECTOR.QUERY.KEYWORD` @ 0.7132 (model load + Rust ANN spawn work in-process)
  - `semantic_embed {type: terms}` — 0 (rows exist, skip correct)
  - `semantic_eval {k: 3}` — 259 pairs, MRR@3 0.0824 (consistent with earlier MRR@5 0.1040)
- Write-path check: `semantic_embed {type: terms, force: true}` → `embedded 15 terms / 15 entities embedded`

## Decisions

- **Shared deps via symlink** (user directive): `tools/mcp-semantic/node_modules` → `.opencode/node_modules`; SDK `^1.16.0` + zod `^4.0.0` resolve from the root plane. Convention documented in root AGENTS.md Tooling section (per `REF.TOOL.NODE_MODULES.SHARED`); matches the archived `mcp-patlib` precedent (its node_modules was also a symlink).
- **Purity split** follows `mcp-patlib` pattern: pure types/format in `_lib/semantic-*.ts`, io in `semantic-query.ts`, thin orchestration in index.ts.
- **Safety**: MCP runs as its own process (like mcp-findings), so `_lib/ann.ts` Rust spawn is safe; model loads once, cached across calls.
- **Eval body bound**: batch-size 2 internally for `documents=body`.

## Open edges

- MCP loads on opencode restart — live agent calls require a restart (config registered, `enabled: true`).
- Stale registrations observed in opencode.json: `patlib`, `mcp-spec-audit`, `mcp-entity-audit` point at `.opencode/tools/*` paths now under `_disabled/` (their `_lib/mcp-*` modules archived). Follow-up audit recommended.
- Smoke harnesses live in `/tmp/opencode/` (`mcp-smoke.ts`, `mcp-embed-force.ts`) — reference only, not repo files.

## Logs

Smoke runs executed directly (bypassing bitacora-log wrapper per the long-run buffering caveat); output captured in session. Prior probe logs: `20260802-111131-probe-s01.log` (bitacora task-stdout).

## Todo state

All items complete — design, libs, server, symlink, registration, smoke test, write-path check, docs, report.
