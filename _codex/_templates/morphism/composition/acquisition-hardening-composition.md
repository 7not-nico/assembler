---
id: MORPHISM.COMPOSITION.ACQUISITION.HARDENING
title: Acquisition Hardening Composition — Probe to Trust
layer: morphism/composition/
purpose: "An acquisition pipeline hardens through a loop: real acquisitions expose failures, the verify probe hardens, transient failures retry, and the URL source becomes trusted — trust earns over runs."
naming: acquisition-hardening-composition.md
tags: [morphism, composition, acquisition, hardening, probe, trust]
status: active
---
# ACQUISITION-HARDENING-COMPOSITION.md

**Layer:** morphism/composition/
**Naming:** `acquisition-hardening-composition.md` — code morphism, reusable structure.
**Composes with:** `morphism/url-from-tool-not-memory.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

An acquisition pipeline hardens through a loop: real acquisitions expose failures, the verify probe hardens to catch them, transient launches retry, and the URL source becomes tool-derived — the pipeline earns trust over successive runs.

## Composition

```text
step 1  acquire   real game acquisitions — failures surface
step 2  harden    verify probe: multi-console exts, bare-ROM detection, sizes
step 3  retry     transient launch retry — blip vs crash
step 4  trust     URL from tool, not memory — provenance over recall
step 5  verify    re-run the acquisitions that failed — all pass
```

Invariant: every failure in a run feeds a hardening step; the probe catches the class of error before it recurs; retries bound transient failures; the tool's output is the only trusted URL source.

## Verification

Replay the acquisition history: each failed acquisition maps to a hardening change (multi-console verify, log-level enablement, console valid-list, URL provenance); the re-runs pass; no failure recurs silently.

## Instance

The acquisition sessions (2026-07-31 through 2026-08-05) — probe hardening (`175000`), transient retries (`191000`), the Phantom 2040 URL lesson, and this session's verify/console/schema fixes — each run hardened the pipeline.
