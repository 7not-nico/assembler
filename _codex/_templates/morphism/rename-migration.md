---
id: MORPHISM.RENAME.MIGRATION
title: Rename Migration — Git MV, Reference Sweep, Verify
layer: morphism/
purpose: "A rename migrates in three steps: git mv preserves history, a reference sweep updates every citation, and a verify pass confirms the renamed artifact serves its consumers."
naming: rename-migration.md
tags: [morphism, rename, migration, git-mv, sweep, verify]
status: active
---
# RENAME-MIGRATION.md

**Layer:** morphism/
**Naming:** `rename-migration.md` — code morphism, reusable structure.
**Composes with:** `morphism/schema-citation-chain.md`; derived from `study/` + `fixture/` proof.

## Morphism

A rename migrates in three steps: `git mv` preserves history, a reference sweep updates every citation (docs, config, server names), and a verify pass confirms the renamed artifact still serves its consumers.

## Structure

```text
step 1  git mv {old} {new}          — history preserved, 100% similarity
step 2  sweep references            — rg old-name → update docs/config/comments
step 3  verify                      — handshake / tools.list / live call / bash -n
```

Invariant: the rename is a move, not a copy (git detects 100% similarity); every reference to the old name updates; the verify pass proves the renamed artifact works — a rename without verify is a broken migration.

## Verification

After a rename: `git log --diff-filter=R` shows the R rename; `rg old-name` returns zero hits in tracked files; the renamed server's tools/list + one live call succeed.

## Instance

This session's renames (2026-08-05) — `pattern/` → `morphism/` (21 files, 100%), `mcp-instantiator` → `mcp-romsfun` (6 files, `87a63ed`), `instantiator/` → `instantiator/romsfun/` (13 files) — each with a reference sweep + verify.
