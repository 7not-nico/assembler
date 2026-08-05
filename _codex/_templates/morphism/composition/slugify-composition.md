---
id: PATTERN.COMPOSITION.SLUGIFY
title: Slugify Composition — Byte-Wise ASCII Dash Slug
layer: pattern/composition/
purpose: "How the slugify binary composes: byte-wise ASCII walk, dash collapse, single trailing extension preserved, three implementations collapsed into one."
naming: slugify-composition.md
tags: [pattern, composition, morphism, binary, slugify]
status: active
---
# SLUGIFY-COMPOSITION.md

**Layer:** pattern/composition/
**Naming:** `slugify-composition.md` — code morphism, reusable structure.
**Composes with:** `pattern/composition/shared-binary-composition.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

The slugify binary composes as a pure byte-wise ASCII transform: split the single trailing extension, walk the base, keep `[a-z0-9]`, collapse runs of anything else into one dash, strip edge dashes, rejoin the extension.

## Composition

```text
step 1  split     dot = LastIndexByte(input, '.')  → base + single trailing ext
step 2  lowercase ASCII A–Z → a–z
step 3  keep      [a-z0-9] bytes; non-ASCII bytes → dashes (byte-wise tr parity)
step 4  collapse  runs of dashes → one; strip leading/trailing
step 5  rejoin    base + "." + ext  (no-ext inputs pass through)
step 6  verify    contract cases: Kirby's Dream Land 2 (...) → kirby-s-dream-land-2-usa-europe-sgb-enhanced
```

Invariant: pure function, no side effects; byte-wise ASCII behavior matches the original bash `tr`; output slugs parse in filenames and URLs.

## Verification

`gofmt -l` empty, `go vet ./...` clean; contract cases: `"Kirby's Dream Land 2 (USA, Europe) (SGB Enhanced).zip"` → `kirby-s-dream-land-2-usa-europe-sgb-enhanced.zip`, `A.B.C.iso` → `a-b-c.iso`, `"."` → `""`, no-ext passthrough.

## Instance

`_shared/cmd/slugify/main.go` (2026-08-05, commit `c328981`) — collapses three bash/JS implementations into one; consumed by `acquire-game.sh` (direct exec) and `shell/slugify.sh` (walk-up shim).
