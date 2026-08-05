---
id: MORPHISM.PATTERN.EVIDENCE.MINING
title: Pattern Evidence Mining — Regex Lines from a Trace
layer: morphism/
purpose: "A trace log is mined by regex patterns — defaults cover known categories, an override file replaces them, each hit emits a deduplicated EVIDENCE= line with context."
naming: pattern-evidence-mining.md
tags: [morphism, pattern, evidence, mining, regex, trace]
status: active
---
# PATTERN-EVIDENCE-MINING.md

**Layer:** morphism/
**Naming:** `pattern-evidence-mining.md` — code morphism, reusable structure.
**Composes with:** `morphism/boot-evidence-enablement.md`; derived from `study/` + `fixture/` proof.

## Morphism

A trace log is mined by regex patterns: a default set covers known evidence categories (boot markers, DMA, BIOS, media codecs), an override file replaces them, and each match emits a deduplicated `EVIDENCE=` line with context plus `LINES=` and `TRACE=`.

## Structure

```text
trace-evidence.sh {trace} [--patterns {file}] [--head {n}]
  DEFAULTS=( 'Booted' 'GBA DMA' 'GBA BIOS' 'GBA Serial I/O' 'SDL Events' ... )
  --patterns → override file (one regex per line)
  for pattern in PATS: rg -m1 -E pattern → dedup → EVIDENCE= line
  LINES={total}  TRACE={file}  EVIDENCE={first hits}
```

Invariant: the default patterns match the enabled log categories; the override file replaces, not appends; each hit is deduplicated; the result lines cite the trace path and the count.

## Verification

Mine an mGBA `-l 127` log — `LINES=6180` with GBA DMA/BIOS/Serial evidence; mine an snes9x log — 4 Alsa lines; a `--patterns` override changes the matched set; a log with no matches returns `LINES=0`.

## Instance

`instantiator/romsfun/trace-evidence.sh` (2026-08-05) — GBA categories added to defaults (commit `91a31ee`); mined 6180 evidence lines from the MMZ2 boot log; the MCP `inst_trace` passes it through.
