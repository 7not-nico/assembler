---
id: MORPHISM.ENABLER.ALIAS.SHIM
title: Enabler Alias Shim — Cite the Binary by Name
layer: morphism/
purpose: "An enabler is a thin walk-up shim in wrapper/enabler/ that cites a shared binary by alias — projects never use the absolute binary path, only the shim name."
naming: enabler-alias-shim.md
tags: [morphism, enabler, alias, shim, walk-up, binary]
status: active
---
# ENABLER-ALIAS-SHIM.md

**Layer:** morphism/
**Naming:** `enabler-alias-shim.md` — code morphism, reusable structure.
**Composes with:** `morphism/walk-up-shim.md`; derived from `study/` + `fixture/` proof.

## Morphism

An enabler is a thin shim under `wrapper/enabler/` that walks up to find a shared binary and execs it — projects cite the alias (`enabler/bitacora.sh`) instead of the absolute binary path, and dive copies carry the enabler.

## Structure

```text
wrapper/enabler/{name}.sh      ← walk-up: find _shared/bin/{name}, exec it
copy-templates.sh              ← carries wrapper/enabler/ into dive copies
citation: bash enabler/{name}.sh {args...}   (never the absolute path)
```

Invariant: the enabler carries resolution only — no logic; the alias is stable across canonical tree and dive copies; the binary is gitignored, the enabler is tracked.

## Verification

Cite the enabler from `_templates/` and from a dive copy — both resolve the binary via walk-up; the exec-tree trace shows the shim replaced by the binary (one exec, no extra processes).

## Instance

`wrapper/enabler/bitacora.sh` → `_shared/bin/bitacora` (2026-08-05) — cited as `bash enabler/bitacora.sh {todo|run|report}`; dive copies carry it; the trace shows `bash → _shared/bin/bitacora → echo` (3 processes, clean exec). Commit `1d1bf73`.
