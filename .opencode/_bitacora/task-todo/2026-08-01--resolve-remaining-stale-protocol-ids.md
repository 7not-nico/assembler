# Resolve Remaining Stale Protocol IDs

Status: in progress (2026-08-01) — wave 4 applied; create-list + regex-fix remain

## Progress 2026-08-01

- [x] PROT.TOOL.MORPHISM → PROT.TOOL.COMPOSITE (title exact match, 14 files) — commit 3a4fb8d
- [x] PROT.META.ENTITY.ROUTING → SPEC.ENTITY.ROUTING.TABLE (spec exists, 10 files) — commit 3a4fb8d
- [x] PROT.LIB.BOUNDARY + PROT.SEARCH.VECTOR.INDEX — NO real referencers (trailing-dot regex artifacts) → fix regex, no data change
- [ ] CREATE new protocols (real refs, no current target): PROT.LLM.SPECIFICATION (22), PROT.LIB.DIRECTORY.LAYER (13), PROT.LIB.PURITY.BOUNDARY (11), PROT.LIB.MUTATION.STRATEGY (7) — per PROT.META.IDENTITY schema
- [ ] fix stale-refs regex: exclude trailing-dot captures (PROT.META.IDENTITY. etc.)
- [ ] broader waves: RUL.WRITING.CONVENTION (44), REF.LIB.DIRECTORY.LAYER (33), MAX.* (25), PAT.* (23) — rename-vs-create decisions
- [ ] scope: sandbox fixtures + template boilerplate in the residual count

## Task (original)

Resolve the 8 ambiguous stale protocol IDs remaining after the rename waves (stale-refs baseline ~2187; count now ~2219 incl. session-log mentions). Each needs either a confirmed rename target or a new protocol entity.

## Stale IDs (from `rs check stale-refs`)

| Stale ID | Count | Decision options |
|----------|-------|------------------|
| PROT.LLM.SPECIFICATION | 22 | create protocol OR map to PROT.META.IDENTITY |
| PROT.LIB.DIRECTORY.LAYER | 13 | create OR map to PROT.LIB.CONTRACT |
| PROT.TOOL.COMPOSITE | 11 | create OR map to PROT.TOOL.COMPOSITE |
| PROT.LIB.PURITY.BOUNDARY | 11 | create OR map to PROT.LIB.ENFORCEMENT |
| PROT.LIB.BOUNDARY | 10 | create OR map to PROT.LIB.CONTRACT |
| PROT.SEARCH.VECTOR.INDEX | 10 | create OR map to PROT.SEARCH.QUERY |
| SPEC.ENTITY.ROUTING.TABLE | 7 | map to SPEC.ENTITY.ROUTING.TABLE |
| PROT.LIB.MUTATION.STRATEGY | 7 | create OR defer |

## Steps

- [ ] check each stale ID's referencers (grep -rl) — which files, what context
- [ ] check current protocol titles for the best rename targets (grep ^title: protocols/*.md)
- [ ] decide per ID: rename-map OR create entity (SPEC.ENTITY.SEGMENT.COUNT governs IDs: 4-segment PROT.*)
- [ ] apply confirmed maps via sed (escaped dots, longest-first, NO experimental lines — wave-3b lesson)
- [ ] create any new protocol entities per PROT.META.IDENTITY schema
- [ ] re-run `./rs check stale-refs` — measure reduction toward 0 real stale refs

## Tooling refinements (after data)

- [ ] stale-refs regex: exclude trailing-dot artifacts (PROT.META.IDENTITY. ×11, PROT.SEARCH.VECTOR.INDEX. ×7)
- [ ] scope check: sandbox fixtures (SANDBOX.*) + template boilerplate — decide exclude or accept
- [ ] full-sweep verification: `./rs audit` all types + `./rs check stale-refs`

## Context

- Waves 1-3 + NEX sweep done: illustrations 57→0, stale-refs 2765→2187
- Corruption incident closed (all 24 sites derived; META.IDENTITY:16 → PROT.RULE.SCHEMA)
- Go toolchain primary (`_golib/`); `rs` → Go binary
- Rule: pipe every command through `bitacora-log.sh {name} -- {command}`
- Precedent for rename waves: `task-stdout/20260801-151915-protocol-rename-wave.log` etc.

## 2026-08-01 addendum — broader stale waves (via `stale-id-list.sh`)

The residual 2187 spans more than the 8 PROT IDs. Top grouped counts:

| Stale ID | Count |
|----------|-------|
| RUL.WRITING.CONVENTION | 44 |
| REF.LIB.DIRECTORY.LAYER | 33 |
| PROT.LLM.SPECIFICATION | 25 |
| MAX.KNOWLEDGE.CLASSIFICATION | 25 |
| MAX.CODE.LAYERS | 25 |
| PAT.SHARED.LIB | 23 |
| PAT.PLUGIN.IPC.TOOL | 23 |
| RUL.CAPTCHA.GATE | 22 |
| REF.LIB.PURITY.BOUNDARY | 22 |
| PAT.MCP.READONLY | 20 |

Scope decision needed: RUL./REF./PAT./MAX. waves — verify whether these are renames (find current targets) or genuinely missing entities (create). Extend the decision process beyond PROT.*.

