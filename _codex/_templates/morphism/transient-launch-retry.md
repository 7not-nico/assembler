---
id: MORPHISM.TRANSIENT.LAUNCH.RETRY
title: Transient Launch Retry — FAIL Once, Retry, Verify
layer: morphism/
purpose: "A transient launch failure (X-display drop, race) retries once before reporting FAIL — the retry distinguishes a crash from a blip, and the verify confirms the second attempt."
naming: transient-launch-retry.md
tags: [morphism, transient, retry, launch, fail, verify]
status: active
---
# TRANSIENT-LAUNCH-RETRY.md

**Layer:** morphism/
**Naming:** `transient-launch-retry.md` — code morphism, reusable structure.
**Composes with:** `morphism/process-launch-health.md`; derived from `study/` + `fixture/` proof.

## Morphism

A transient launch failure retries once before reporting FAIL: the first FAIL (X-display drop, server race) is followed by a second launch, and the verify confirms the retry — a blip is not a crash.

## Structure

```text
launch → FAIL "emulator exited early — crash or missing window"
retry  → launch again (same binary + ROM)
verify → RUN pid= + kill -0  → SUCCESS
persist → still FAIL after retry → report the crash with the log
```

Invariant: the retry happens once, automatically; a transient cause (X connection broken, display race) clears on the second attempt; a persistent failure still reports FAIL with the log; the success after retry is recorded.

## Verification

Launch an emulator during a display hiccup — first FAIL, retry succeeds (RUN pid=); launch a genuinely broken ROM — FAIL persists across the retry with the log tail; the retry is bounded (once, never an infinite loop).

## Instance

The snes9x acquisitions (2026-07-31) — Blues Brothers + Gundam Wing both failed first launch with `X connection to :0 broken`; the retry succeeded; recorded in `20260731-191000-late-acquisitions-transient-failures.md`.
