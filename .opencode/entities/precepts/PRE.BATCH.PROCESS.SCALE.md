---
id: PRE.BATCH.PROCESS.SCALE
title: Batch Process — Parallel Minimal Segments, Never Full Sequential
source: assembler
summary: "All batch operations follow throughput model T(B) = B / (S + pB). Full sequential processes never run. Operations decompose into parallel minimal segments, each in its own process. Concurrency P = min(floor(RAM / model_size), N_segments)."
precept: Parallel minimal segments, never full sequential. Every batch operation divides into independent segments processed in parallel.
enforcement: Convention
tags: [architecture, batch, concurrency, parallel, throughput, optimization]
status: active
priority: 2
---

**Batch Process** — parallel minimal segments, never full sequential. T(B) = B / (S + pB).

## Corollaries

- Full sequential processes never run. Every operation decomposes into independent parallel segments
- Each segment runs in its own child process. One type per process. One domain per process
- No single segment exceeds the event-loop block threshold (empirically determined, typically <500ms)
- Concurrency bounded by available RAM. Each process reserves its own model memory. At memory saturation, queue remaining segments
- Optimal batch size B* is the Pareto point: largest B before throughput gains per unit B drop below 1.2x
- Segments with zero work exit immediately — no model load, no process overhead

## Applicability

All batch operations across all projects: vector embedding, data migration, file processing, API scraping. Not applicable to single-item operations or real-time request handling where latency is the binding constraint.
