# Batch optimization — mathematical ratio

**Maxim refs:** MAX.KNOWLEDGE.CLASSIFICATION (scientific method: measure → model → predict)  
**Papers:** findings/batch-optimization/throughput-ratio/

## Derived ratio (qalc verified)
T(B) = B / (0.002 + 0.003B + 0.048)  items/s

Batch  Optimal  Throughput  Block/type  RAM
B=1    —        18.9/s      —           —
B=16   current  163.3/s     0.72s       —
B=32   SWEET    219.2/s     0.38s       —
B=64   dim ret  264.5/s     0.19s       —

## Concurrency
P=4: 4×250MB = 1GB RAM, all 16 types ~2s wall time
B=32 + P=4: 32% more throughput, 47% less block vs B=16

## Done
- [x] batchSize updated from 16→32 in reindex-vectors.ts
- [x] reindex tool verified — single type per process
- [x] parallel runner pattern: `for t in types; do reindex $t &; done; wait`

## To test (user: real computational knowledge & patterns)
- [ ] test: B=32 single type — block time < 400ms?
- [ ] test: P=4 parallel — total < 3s wall time?
- [ ] test: RAM usage — 4 processes fit?
