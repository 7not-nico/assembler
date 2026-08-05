---
id: PATTERN.PURITY.PORT.PIPELINE
title: Purity-Split Port — Python Proof, Go Production
layer: pattern/
purpose: "A flow proves in typed python (pure core + io edge), then ports to Go once sound — the same split carries over, structures map directly."
naming: purity-port-pipeline.md
tags: [pattern, morphism, purity, port, python, go]
status: active
---
# PURITY-PORT-PIPELINE.md

**Layer:** pattern/
**Naming:** `purity-port-pipeline.md` — code morphism, reusable structure.
**Composes with:** `pattern/shared-binary-composition.md`; derived from `study/` + `fixture/` proof.

## Morphism

A flow proves in typed python first (pure core + io edge, ring-annotated), then ports to Go once the logic is sound — the purity split carries over file-for-file, and the data structures map directly.

## Structure

```text
phase 1  python proof    shell/bin/{flow}-pyfolder/
    r0_{core}.py    — pure: types + builders, no I/O (ring 0)
    r4_{edge}.py    — io: writes + subprocess (ring 4)
    r4-{flow}       — ring-prefixed executable entry
phase 2  verify        — full matrix (exit codes, no-clobber, trace)
phase 3  go port       _shared/cmd/{flow}/
    {core}.go   — pure: Record struct, body/frame builders
    {write,run}.go — io: fs + subprocess
    main.go     — thin dispatch
phase 4  re-verify     — same matrix against the Go binary
```

Invariant: the python phase proves behavior; the Go phase proves production; the purity boundary survives the port (pure packages testable with no setup); the matrix is the contract both must pass.

## Verification

Run the identical 14-case matrix (todo/report open, no-clobber, missing-arg, run success/failure/echo/empty/missing-cmd 127/trace, no-subcommand) against both binaries — identical exit codes; pure-package unit tests pass with no fs setup in both languages.

## Instance

The bitacora flow (2026-08-05) — `shell/bin/bitacora-pyfolder/` (python proof, 15/15) then `_shared/cmd/bitacora/` (Go, 14/14 + unit tests); the `Record` dataclass → struct and tuple commands → slices mapped directly.
