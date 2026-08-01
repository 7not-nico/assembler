# Batch Processing — Mathematical Ratio Report

## Throughput Model

T(B) = B / (S + p·B)

| Symbol | Value | Description |
|--------|-------|-------------|
| B | — | Batch size |
| S | 48ms | ONNX WASM single-thread overhead per batch |
| p | 3ms | Per-item embedding time (384-dim) |

## Throughput at Batch Sizes

| B | Items/s | Gain vs B=1 | Block/99 | Block/228 |
|---|---------|-------------|----------|-----------|
| 1 | 19.6 | 1× | 4.8s | 10.9s |
| 8 | 111.1 | 5.7× | 0.58s | 1.4s |
| 16 | 166.7 | 8.5× | 0.29s | 0.72s |
| **32** | **222.2** | **11.3×** | **0.19s** | **0.38s** |
| 64 | 266.7 | 13.6× | 0.10s | 0.19s |

## Marginal Gain (diminishing returns)

| Transition | Gain | Block reduction | Verdict |
|--------|------|----------------|---------|
| B=1→B=8 | 5.7× | 88% | Essential |
| B=8→B=16 | 1.5× | 50% | Good |
| B=16→B=32 | 1.33× | 34% | Pareto-optimal |
| B=32→B=64 | 1.2× | 50% | Diminishing |

## Concurrency Model

P* = min(floor(RAM_avail / 250MB), N_types_with_data)

- Each process: 200MB model + 50MB overhead = 250MB
- At 1GB RAM: P* = 4
- Wall time: ceil(N/P*) × (289ms model_load + max_type_time)
- For 4 types at P=4: ~0.55s total

## Optimal Configuration

- **Batch size:** B=32 (Pareto-optimal point)
- **Concurrency:** P=4 (RAM-bound, 1GB)
- **Process model:** One type per process, no `--all`
- **Block time:** < 200ms for worst type (33 terms × 3 scopes = 99 embeds)

## References

- findings/batch-optimization/papers/2510.17885-throughput-metrics.pdf
- findings/batch-optimization/papers/2503.05248-dynamic-batching.pdf
- findings/batch-optimization/papers/2009.09433-throughput-optimization-batch-processing.pdf
- findings/batch-optimization/papers/osdi24-throughput-latency-tradeoff.pdf
- MAX.BATCH.PROCESS
