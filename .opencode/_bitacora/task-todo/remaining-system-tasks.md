# Remaining system tasks

## Low priority
- [ ] update MCP servers to restart after entity type changes (cognitions, concepts, definitions missing from type enum)
- [ ] fix entity-audit MCP server path (looks at .opencode/protocols/ not .opencode/entities/protocols/)
- [ ] add embedding LRU cache for repeated queries
- [ ] integrate bench-vectors into CI check

## Done this session
- [x] Terms classification: 16 COG + 23 CON + 2 DEF + 33 TERM
- [x] 6 protocol/reference updates
- [x] 3 new maxims (BATCH.PROCESS, SYNC.STALE.CLEANUP, ENTITY.RECLASSIFY)
- [x] 1 new rule (FUNCTION.SIGNATURE)
- [x] reindex-vectors CLI tool with B=32
- [x] stale row cleanup in syncTable()
- [x] cross-ref audit: 49+ stale refs fixed
- [x] bench-vectors.ts test tool
- [x] vector-bench.ts shared lib
- [x] 7 reports in .opencode/reports/
- [x] 5 papers in findings/batch-optimization/
