# Semantic embedding metrics

## Change set

- `bge-small-en-v1.5` pooling: mean → CLS
- Query encoding: added `Represent this sentence for searching relevant passages: `
- Re-embed mode: `semantic-embed.ts --force`

## Index health

| Metric | Result |
|---|---:|
| Entity tables | 28 |
| Indexed entities | 558 |
| Missing vectors | 0 |
| Stale vectors | 0 |
| Vector dimension | 384 |
| Model | Xenova/bge-small-en-v1.5 |

## Query: `cognition computer science`

| Rank | Score | ID |
|---:|---:|---|
| 1 | 0.7469 | PROT.COGNITION.SCHEMA |
| 2 | 0.7218 | COG.COMPUTER.SCIENCE |
| 3 | 0.7199 | IDENTITY.COGNITION |
| 4 | 0.6813 | CON.MACHINE.LEARNING |
| 5 | 0.6808 | CON.NEURAL.NETWORK |

## Before/after comparison

| Entity | Before rank/score | After rank/score | Score delta |
|---|---:|---:|---:|
| IDENTITY.COGNITION | 1 / 0.7633 | 3 / 0.7199 | -0.0434 |
| PROT.COGNITION.SCHEMA | 2 / 0.6979 | 1 / 0.7469 | +0.0490 |
| COG.COMPUTER.SCIENCE | 3 / 0.6846 | 2 / 0.7218 | +0.0372 |

Top-10 overlap: 5/10 IDs.

## Verification

```text
semantic-drift --check → 0 missing, 0 stale across 28 tables
semantic-embed --force → 558 entities embedded
```

## Remaining metric edge

MRR@10 baseline and controlled relevance labels remain pending. Rank changes show retrieval movement, not validated quality gain.
