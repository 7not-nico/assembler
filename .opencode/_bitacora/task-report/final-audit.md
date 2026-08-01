# Final Audit Report

## File Integrity

| Check | Result |
|-------|--------|
| Entity files scanned | 275 |
| Parse failures | 0 |
| File size range | 629–8178 bytes (avg 2812) |

## Entity File Counts (file system vs DB)

| Type | Files on disk | DB rows | Match |
|------|--------------|---------|-------|
| Cognitions | 16 | 16 | ✓ |
| Concepts | 23 | 23 | ✓ |
| Definitions | 2 | 2 | ✓ |
| Terms | 33 | 33 | ✓ |
| Maxims | 18 | 18 | ✓ |
| Patterns | 7 | 7 | ✓ |
| Protocols | 36 | 36 | ✓ |
| References | 34 | 34 | ✓ |
| **Total** | **169** | **169** | **✓** |

## Cross-Reference Integrity

| Check | Before | After |
|-------|--------|-------|
| Orphan entity_terms | 7 | 0 |
| Orphan entity_patterns | 88 | 0 |

## Stale Row Cleanup

| Test | Result |
|------|--------|
| syncTable stale cleanup | Verified — MAX.SYNC.STALE.CLEANUP confirmed |
| Manual DELETE fallback | Works (used during migration) |

## Papers

| Paper | Location | Topic |
|-------|----------|-------|
| 2510.17885 | findings/batch-optimization/papers/ | Throughput metrics |
| 2503.05248 | same | Dynamic batching |
| 2009.09433 | same | Batch processing optimization |
| osdi24 | same | Throughput-latency tradeoff |
| MTEB benchmark | same | Embedding model comparison |

## All Reports

`.opencode/reports/` (7 files, 275 parse-checked entities, 169 file-to-DB matches)
