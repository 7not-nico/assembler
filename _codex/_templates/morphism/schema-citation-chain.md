---
id: MORPHISM.SCHEMA.CITATION.CHAIN
title: Schema Citation Chain — One Home for Constants
layer: morphism/
purpose: "Hardcoded values live in one schema (seed.sql); tools cite it via lookup; wrappers delegate; the MCP server passes through — a single home, a strict citation chain."
naming: schema-citation-chain.md
tags: [morphism, schema, constants, citation, chain, values]
status: active
---
# SCHEMA-CITATION-CHAIN.md

**Layer:** morphism/
**Naming:** `schema-citation-chain.md` — code morphism, reusable structure.
**Composes with:** `morphism/wrapper-delegation.md`; derived from `study/` + `fixture/` proof.

## Morphism

Hardcoded values live in exactly one schema — `seed.sql` in the `shell_values` table; tools cite it through a lookup that exports `SCHEMA_{KEY}` vars; wrappers delegate; the MCP server passes through — so every constant has one home and the citation chain is the architecture.

## Structure

```text
schema/seed.sql    ← the ONLY home for constants (INSERT OR IGNORE INTO shell_values)
    ↓ cited by
schema/lookup.sh   ← exports each row as SCHEMA_{KEY}
    ↓ sourced by
the .sh tools      ← use $SCHEMA_* — never hardcode
    ↓ wrapped in
wrapper/           ← thin delegation
    ↓ cited by
the MCP server     ← default-free, passes through
```

Invariant: a constant appears once — in `seed.sql`; a tool never hardcodes a value; a caller that omits an arg gets the shell's schema value; the MCP server carries no defaults.

## Verification

Scan the tools for hardcoded constants — the only hits are `$SCHEMA_*` references; change a value in `seed.sql` and every tool picks it up without an edit; omit an arg through the MCP and the shell's schema default applies.

## Instance

`instantiator/romsfun/schema/` (2026-08-05) — 9 value rows (CDP ports, CONSOLE_VALID, timeouts, TRACE_HEAD, IMAGE_EXTS, LAUNCH_LOG, FETCH_SELECTOR); 7 tools cite it; both MCP servers default-free. Commit `fc5feaf`.
