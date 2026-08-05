---
id: MORPHISM.URL.FROM.TOOL.NOT.MEMORY
title: URL From Tool, Not Memory — Provenance Over Recall
layer: morphism/
purpose: "A variant URL derives from the browse tool's output, never from memory — a mis-typed remembered URL silently acquires the wrong artifact."
naming: url-from-tool-not-memory.md
tags: [morphism, url, provenance, tool, memory, acquisition]
status: active
---
# URL-FROM-TOOL-NOT-MEMORY.md

**Layer:** morphism/
**Naming:** `url-from-tool-not-memory.md` — code morphism, reusable structure.
**Composes with:** `morphism/keyed-line-handoff.md`; derived from `study/` + `fixture/` proof.

## Morphism

A variant URL derives from the browse tool's machine lines, never from memory — a mis-typed remembered URL silently acquires the wrong artifact, and the tool's output is the only trustworthy source.

## Structure

```text
browse → GAME/DL/VARIANTS machine lines (the tool's output)
fetch  → consume the URL from those lines, never retype it
verify → confirm the artifact matches the intended title
```

Invariant: the URL passes from the tool's stdout to the fetcher unchanged; a remembered or hand-typed URL is a provenance violation; the verify step catches a mismatch before the wrong ROM stages.

## Verification

Extract a variant URL from browse output and fetch — the artifact matches the intended game; hand-type a remembered URL with one digit wrong — the verify returns a different title, catching the error.

## Instance

The Phantom 2040 accident (2026-07-31) — a mis-typed remembered Blues Brothers URL (`blues-brothers-145491/2`) acquired Phantom 2040 (Beta) instead; the lesson recorded: variant URLs derive from `browse-romsfun.sh` output, never from memory.
