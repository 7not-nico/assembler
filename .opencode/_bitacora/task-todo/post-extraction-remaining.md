# Post-extraction remaining tasks

**Maxim refs:** MAX.CATALYST.FOR.CHANGE (ship smallest useful), MAX.DRY (further extraction), MAX.ORTHOGONALITY (domain separation)

## Done — vector search monolith extraction

- [x] `_lib/entity-paths.ts` — entitySourcePath + entityMtime
- [x] `_lib/reindex-entity.ts` — parameterized reindexEntityType
- [x] `mcp-patlib-vector` uses shared `_lib/vector-db.ts` (was duplicate)
- [x] `mcp-patlib-vector/index.ts` 398→215 LOC
- [x] `reindex-vectors.ts` 120→41 LOC
- [x] `jsonResponse()` + `withDB()` helpers extracted
- [x] Unused imports (`Database`, `entityTable`) removed
- [x] Build verified — 0 errors across all 4 files
- [x] Bug fix: `entitySourcePath()` used for `srcPath` (was passing `item.id`)
- [x] Runtime verified: `reindex-vectors.ts --type definitions --force` — 6 embeddings created
- [x] Runtime verified: `bench-vectors.ts --quick` — 5/5 FTS5 hits, 80% hybrid
- [x] `useMtime=true` incremental skip: confirmed (first run 2 inserted, second 2 skipped)
- [x] `force=true` bypass: confirmed (re-embeds everything)
- [x] Behavioral fidelity preserved: CLI `useMtime=false` matches pre-extraction behavior
- [x] Node modules DRY fix: `mcp-patlib-vector/node_modules` → shared symlink (was own copy, ~34MB)
- [x] Shared native binary rebuild: `npm rebuild sharp` in root (was missing after symlink switch)
- [x] All 4 MCP servers verified: shared symlink to root `.opencode/node_modules/`
- [x] Final runtime validation: `reindex-vectors --type maxims` (54 embeddings), `bench-vectors --quick` (unchanged)
- [ ] Restart opencode runtime to clear MCP module cache

## Remaining — other _lib/ tool-specific modules

Per MAX.ORTHOGONALITY, these `_lib/` modules are single-tool and could move to their tool directories:

| Module | Used by | Current | Target |
|--------|---------|---------|--------|
| `spec-audit.ts`, `spec-format.ts`, `spec-rules.ts`, `spec-types.ts` | `mcp-spec-audit` only | `_lib/` | `tools/mcp-spec-audit/lib/` |
| `entity-audit.ts`, `entity-format.ts` | `mcp-entity-audit` only | `_lib/` | `tools/mcp-entity-audit/lib/` |
| `arxiv-format.ts`, `arxiv-parse.ts`, `arxiv-types.ts` | `arxiv-search.ts` only | `_lib/` | `tools/arxiv-search/lib/` |

Priority: low — these are single-consumer modules with no duplication to eliminate. Extraction would improve ORTHOGONALITY but adds import path complexity.

## Remaining — COG/CON/DEF entity type support

Per `code-infrastructure.md` and `remaining-tasks.md`:
- [ ] Wire COG/CON/DEF into `_lib/vector-query.ts` ENTITY_TYPES (if not already)
- [ ] Wire into `_lib/entity-text.ts` ENTITY_BODY_TABLES
- [ ] Wire into `_lib/mcp-types.ts` ID_PREFIX_TO_ENTITY_TYPE
- [ ] DEF migration: 5 remaining term→def candidates
- [ ] TERM `type:` field: 44 remaining files

## Remaining — operational

- [ ] Restart opencode runtime (clears MCP module cache, picks up schema split + new _lib/ modules)
- [ ] Full reindex: `for t in patterns terms skills commands protocols illustrations maxims; do bun run reindex-vectors.ts --type $t; done`
