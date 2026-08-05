---
id: PATTERN.LOCATION.AWARE.WALKUP
title: Location-Aware Walk-Up — Resolve from Own Location
layer: pattern/
purpose: "A script resolves the shared root by walking up to a named ancestor from its own location."
naming: location-aware-walk-up.md
tags: [pattern, morphism, resolution, walk-up]
status: active
---
# LOCATION-AWARE-WALK-UP.md

**Layer:** pattern/
**Naming:** `location-aware-walk-up.md` — code morphism, reusable structure.
**Composes with:** `pattern/shared-deps-binary.md`; derived from `study/` + `fixture/` proof.

## Morphism

A script resolves the shared root by walking up to a named ancestor from its own location, so canonical files and copied files resolve the same way.

## Structure

```text
d = dirname of BASH_SOURCE[0]
while d != "/":
    if d/_shared/bin/codexroot exists: SHARED_BIN = d/_shared/bin; return
    d = dirname d
error: hint naming the missing ancestor
```

Fixed-depth variant: `instantiator/deps/paths.sh` resolves `../../_shared/bin` — safe because instantiator tools never copy into dives. Invariant: resolution depends on location, never on the caller's cwd.

## Verification

Source the deps from the canonical path and from a copied location under `_codex/` — both resolve; a copy outside `_codex/` exits with the hint; `codexroot` accepts relative args because it absolutizes before walking.

## Instance

`shell/deps/paths.sh` `resolve_shared` + `_shared/cmd/codexroot` (2026-08-05) — the dive-copy `run-logged.sh` case that previously failed the location case now resolves via the walk-up.
