---
id: PATTERN.RING.PREFIXED.MODULE
title: Ring-Prefixed Module — Purity and Ring in the Name
layer: pattern/
purpose: "A flow splits into ring-prefixed modules — r0_ pure core, r4_ io edge, r4- executable — the ring and purity read from the filename itself."
naming: ring-prefixed-module.md
tags: [pattern, morphism, ring, purity, module, naming]
status: active
---
# RING-PREFIXED-MODULE.md

**Layer:** pattern/
**Naming:** `ring-prefixed-module.md` — code morphism, reusable structure.
**Composes with:** `pattern/purity-port-pipeline.md`; derived from `study/` + `fixture/` proof.

## Morphism

A flow splits into ring-prefixed modules — `r0_` for the pure core, `r4_` for the io edge, `r{ring}-` for the executable entry — so the ring and purity read from the filename before the file opens.

## Structure

```text
{flow}-pyfolder/
├── r0_{core}.py      ← ring 0 (PURE): types + builders, no I/O
├── r4_{edge}.py      ← ring 4 (LOCAL-WRITE): fs writes + subprocess
└── r4-{flow}         ← ring-prefixed executable: thin entry, imports r4
```

Every module header carries the annotations: `# ring: N (RING-NAME)` + `# purity: pure|io` + `# depends-on:` — the contract lives in the header, the ring in the name.

## Verification

`ls` the folder — the dependency direction reads top-to-bottom (r0 → r4 → entry) without opening a file; a pure module imported anywhere has no fs side effects; the ring number matches the annotation in every header.

## Instance

`shell/bin/bitacora-pyfolder/` (2026-08-05) — `r0_record.py` (pure core) + `r4_bitacora.py` (io edge) + `r4-bitacora` (entry); the split survived the Go port file-for-file.
