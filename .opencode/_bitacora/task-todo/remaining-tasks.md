# Remaining work

## DEF migration
- [ ] identify terms that describe physical things (5 candidates)
- [ ] migrate to definitions/ with DEF.* prefix
- [ ] source = COG.* ID
- [ ] update cross-refs
- [ ] reindex

## TERM type field
- [ ] 44 remaining terms need type: internal|external
- [ ] Most are internal (source: assembler) 
- [ ] Some may be external (source: non-assembler)
- [ ] Batch-update frontmatter in all 44 files

## Stale row cleanup in syncTable()
- [ ] _lib/sync.ts syncTable() doesn't clean stale DB rows
- [ ] Add cleanup: DELETE WHERE id NOT IN (file_ids)
- [ ] Affects: terms, cognitions, concepts, definitions

## Full reindex
- [ ] bun run reindex-vectors.ts --type rules
- [ ] bun run reindex-vectors.ts --type skills
- [ ] bun run reindex-vectors.ts --type commands
- [ ] bun run reindex-vectors.ts --type protocols
- [ ] bun run reindex-vectors.ts --type illustrations
- [ ] bun run reindex-vectors.ts --type maxims
- [ ] (all remaining types not yet indexed)

## Verify
- [ ] patlib_vector_search returns results for COG.* and CON.*
- [ ] no stale TERM.* vectors remain
- [ ] all entity types have embeddings
