# Batch processing mathematical ratio

**Model:** T(B) = B / (S + p·B)  where S=48ms overhead, p=3ms/item  
**Source:** "Metrics and evaluations for computational and sustainable AI efficiency" (2510.17885)

## Key ratios (qalc verified)

B=1:   19.6 items/s  (baseline)
B=16:  166.7 items/s (8.5x)
B=32:  222.2 items/s (11.3x) ← CURRENT
B=64:  266.7 items/s (13.6x — diminishing)

Gain per double: B16/B8=1.5x, B32/B16=1.33x, B64/B32=1.2x

## Block time (228 embeds, terms type)

B=4:  57 batches × 48ms = 2736ms  ✗ STALL
B=16: 15 batches × 48ms = 720ms   ✗ perceptible
B=32:  8 batches × 48ms = 384ms   ✓ acceptable
B=64:  4 batches × 48ms = 192ms   ✓ optimal block

## Papers
- [x] 2510.17885 — Throughput metrics and evaluation framework
- [x] 2503.05248 — Memory-aware dynamic batching
- [x] 2009.09433 — Throughput optimization in batch-processing systems
- [x] 2507.07101 — Small batch size training for LMs
- [x] 2412.04504 — Multi-bin batching for LLM inference

## Decision
- [x] B=32 selected (Pareto-optimal: throughput vs block time)
- [x] reindex-vectors.ts updated with B=32
- [x] Single-type-per-process pattern (not --all)
