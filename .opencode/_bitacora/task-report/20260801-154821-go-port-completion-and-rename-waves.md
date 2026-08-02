# Go Port Completion and Rename Waves

Timestamp: 2026-08-01 154821

## What was done

**1. Go toolchain port finished.** `_scripts/_golib/` (module `assembler/scripts/golib`, go 1.26, stdlib-only) builds, vets, and runs as the primary scripts runtime. The `rs` launcher execs `_golib/bin/assembler-cli` (Rust binary fallback). All 23 entity types load — the encyclopedic backmatter gap (cognitions 0 in Rust) is closed: cognitions 35, concepts 62, terms 28 (Ruby parity). `_scripts/AGENTS.md` rewritten: Go primary, Rust/Ruby legacy, module table, quick start, Go naming conventions.

**2. Protocol rename wave applied (confirmed mappings only).** Three waves system-wide across 3697 `.md` files (escaped dots, longest-first):
- Wave 1 (26 maps): `PROT.TOOL.CUSTOM.DEFINITION→PROT.TOOL.DEFINITION`, `PROT.LIB.MODULE.CONTRACT→PROT.LIB.CONTRACT`, `PROT.MCP.STDIO.TRANSPORT→PROT.MCP.TRANSPORT`, `PROT.META.PROTOCOL.*→PROT.META.*`, NEX 4-segment→3-segment, etc.
- Wave 2 (9 maps): `PROT.{TYPE}.IDENTITY[.SCHEMA]→PROT.{TYPE}.SCHEMA`, `PROT.TOOL.PROJECT.SCOPE→PROT.TOOL.SCOPE`, `PROT.TOOL.PLUGIN.VALIDATION→PROT.TOOL.COMPLIANCE`, `PROT.TOOL.LAYER.CHOICE→NEX.TOOL.CHOICE` (scoped)
- Wave 3 (6 maps): `PROT.{CONCEPT,DEFINITION,ILLUSTRATION,ML,RULE,TAX}.IDENTITY→*.SCHEMA`
- NEX sweep in illustrations/skills (wave-1 gap): 7 old NEX names → current

**3. Corruption incident repaired.** Wave-3b carried an accidental stray `sed "s/${old%%.}/X/"` that replaced `PROT.{TYPE}` with bare `X` in 24 sites (including already-correct `PROT.{TYPE}.SCHEMA` cross-refs). All 24 repaired by context reconstruction (identity files, audit-rule SKILL.md, 10 backtick schema cross-refs). Corruption was invisible to the audit tools (prefix `X` not ID-shaped) — found via targeted grep.

**4. Verification (logged):** backtick `X.SCHEMA` → 0; bare-X metadata scan clean (entities + knowledge/codex/atelier); audits: protocols 0, maxims 0, illustrations 0, nexus 0, patterns 0, persons 8 (documented filename convention only); stale-refs 2765 → **2187**.

## Decisions

- Go becomes primary; Rust `_rs`/`_bin` and Ruby `_rb` stay legacy (user direction "derive new shared code in go instead")
- Stdlib-only Go (no YAML dep) — lenient field parser matches the Ruby constraint and the `ann.go` zero-dep precedent
- Rename waves applied only where a 1:1 current target exists; ambiguous IDs deferred to crossref-audit backlog
- `PROT.TOOL.LAYER.CHOICE` mapped to `NEX.TOOL.CHOICE` (the nexus exactly titled "Tool Layer Choice"); `PROT.TOOL.PLUGIN.VALIDATION` → `PROT.TOOL.COMPLIANCE`
- Over-permissive Go loading accepted (2-file diff vs Ruby)
- Corruption repair used context reconstruction; one ambiguous site flagged

## Open edges

- ~~`PROT.META.IDENTITY.md:16` reconstruction~~ — **resolved**: derived **PROT.RULE.SCHEMA** from the document's own identity-protocol enumeration (lines 76–78 pair MAXIM + RULE; the RULE-map iteration corrupted both line 16 and 78). Verified consistent; residual `X.SCHEMA` 0. All 24 corruption sites now carry derived-or-context-confirmed IDs.
- Remaining stale IDs (8, enumerated in crossref-audit todo): PROT.LLM.SPECIFICATION (22), PROT.LIB.DIRECTORY.LAYER (13), PROT.TOOL.COMPOSITE (11), PROT.LIB.PURITY.BOUNDARY (11), PROT.LIB.BOUNDARY (10), PROT.SEARCH.VECTOR.INDEX (10), SPEC.ENTITY.ROUTING.TABLE (7), PROT.LIB.MUTATION.STRATEGY (7) — decision or entity creation
- Trailing-dot false positives in the stale-refs regex (`PROT.META.IDENTITY.` ×11) — tool refinement candidate
- Sandbox fixtures + template boilerplate dominate the residual 2187 — verify scope before cleanup
- Wave-3b lesson: no experimental seds in production sweeps

## Todo state

- `task-todo/2026-08-01--go-scripts-toolchain.md` — completed
- `task-todo/2026-08-01--continue-session-queue.md` — in progress (repairs + verification done; META.IDENTITY:16 sign-off + reports remaining)
- `task-todo/crossref-audit.md` — updated with remaining stale-ID enumeration
- Prior 2026-08-01 todos: all completed

## Logs

- `task-stdout/20260801-153627-corruption-repair-2.log` — 10 backtick sites restored, 0 residual
- `task-stdout/20260801-153710-nexus-sweep-illustrations.log` — 7 old NEX names swept in illustrations/skills
- `task-stdout/20260801-153717-verify-after-repair.log` — audits clean, stale-refs 2187, bare-X clean
- `task-stdout/20260801-151915-protocol-rename-wave.log` — wave 1 (26 maps)
- `task-stdout/20260801-152250-protocol-rename-wave-2.log` — wave 2 (9 maps)
- `task-stdout/20260801-152716-protocol-rename-wave-3b.log` — wave 3 (6 maps; incident source)
- `task-stdout/20260801-151828-stale-refs-sweep.log` — baseline 2765
