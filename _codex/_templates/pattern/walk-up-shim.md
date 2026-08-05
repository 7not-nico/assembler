---
id: PATTERN.WALKUP.SHIM
title: Walk-Up Shim — Legacy Call Site, Shared Binary
layer: pattern/
purpose: "A thin shim resolves _shared/bin by walk-up and execs the Go binary, so established call sites keep their path while the algorithm moves to the shared layer."
naming: walk-up-shim.md
tags: [pattern, morphism, shim, walk-up, shared, binary]
status: active
---
# WALK-UP-SHIM.md

**Layer:** pattern/
**Naming:** `walk-up-shim.md` — code morphism, reusable structure.
**Composes with:** `pattern/location-aware-walk-up.md` + `pattern/shared-binary-composition.md`; derived from `study/` + `fixture/` proof.

## Morphism

A thin shim resolves `_shared/bin/{name}` by walking up from its own location and execs the Go binary, so established call sites keep invoking the shim path while the algorithm lives once in the shared layer.

## Structure

```text
shim.sh {args...}
    d = dirname $0
    walk up: [ -x "$d/_shared/bin/{name}" ] → exec "$d/_shared/bin/{name}" "$@"
    root:    echo resolution hint >&2; exit 1
```

Invariant: the shim carries no algorithm — only resolution and exec; call sites keep a stable path; the binary replaces multiple implementations without touching call sites.

## Verification

Run the shim from the canonical tree and from a dive copy — both exec the binary; run it with no `_shared` ancestor — the hint exits 1; the byte-wise output matches the replaced bash/JS implementation.

## Instance

`shell/slugify.sh` (2026-08-05, commit `c328981`) — replaces the bash `tr`-based slug with the Go binary; `acquire-game.sh` execs `_shared/bin/slugify` directly, no shim.
