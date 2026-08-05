---
id: PATTERN.INPUT.FINGERPRINT
title: Input Fingerprint — Prove What a Run Consumed
layer: morphism/
purpose: "A logged run fingerprints its declared inputs (--in f1,f2) as per-file sha256 — the record proves exactly what the run consumed."
naming: input-fingerprint.md
tags: [pattern, morphism, fingerprint, sha256, inputs, provenance]
status: active
---
# INPUT-FINGERPRINT.md

**Layer:** morphism/
**Naming:** `input-fingerprint.md` — code morphism, reusable structure.
**Composes with:** `morphism/session-provenance.md`; derived from `study/` + `fixture/` proof.

## Morphism

A logged run fingerprints its declared inputs — `--in f1,f2` → `IN_SHA` with a per-file sha256 — so the record proves exactly what the run consumed, and a changed input is visible in the record.

## Structure

```text
--in f1,f2 → IN_SHA="f1=<sha256> f2=<sha256> "
missing file → IN_SHA="f1=missing "
header/IN:  the fingerprint lands in the provenance header
```

Invariant: the fingerprint is per-file and cryptographic; a missing declared input is recorded as `missing`, never silently dropped; the same file at a different revision yields a different fingerprint.

## Verification

Run with `--in a.txt` — the header carries `a.txt=<sha256>`; modify a.txt and rerun — the fingerprint changes; declare a nonexistent file — the header records `a.txt=missing`.

## Instance

Root `.opencode/_bitacora/bitacora-log.sh` (reference) — `IN_SHA` per-file hashing of `--in` inputs (2026-08-05 observed); the codex dive flow has not yet adopted it — an open edge.
