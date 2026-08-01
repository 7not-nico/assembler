---
id: PRE.STALL.ENGINE.BATCH
title: Stall Engine — Never Block the Runtime, Batch in Parallel
source: assembler
summary: "Long sequential operations block the runtime (stall the engine). Every operation decomposes into small parallel batches. No single batch exceeds the engine's responsiveness threshold. An isolated process that survives its full operation is the right scale; one that gets terminated is too large."
precept: Never block the runtime. Batch in parallel. If a subprocess gets terminated, the batch is too large.
enforcement: Convention
tags: [architecture, concurrency, parallel, responsiveness, batch, runtime]
status: active
priority: 2
---

**Stall Engine** — never block the runtime. Batch in parallel. If a process gets terminated, the batch is too large.

## Corollaries

- No sequential loop over all N items in a single process. Decompose into parallel batches
- If a subprocess is terminated, assume the batch was too large — halve the batch size and retry
- The runtime's responsiveness takes priority over throughput. A responsive system at 80% throughput beats a stalled system at 100%
- Parallelism P = min(floor(RAM_avail / RAM_per_process), N_batches). Never exceed available RAM
- Batch size defaults to 8 for operations with unknown memory profile. Scale up only after confirming the process survives
- An operation that cannot complete within the runtime's capacity threshold must be deferred to an external scheduler (cron, background worker)

## Applicability

All operations invoked through the runtime: vector embedding, data migration, batch file processing, API scraping. Does not apply to operations running outside the runtime context (standalone CLI, cron jobs, CI pipelines).
