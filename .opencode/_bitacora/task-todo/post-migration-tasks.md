# Post-classification tasks

## Cross-reference audit
- [ ] grep for TERM.* IDs in all entities — find stale refs to reclassified terms
- [ ] update refs: TERM.ABSTRACT → CON.ABSTRACT, etc.
- [ ] verify: write-sync confirms all refs resolve

## Entity type support
- [ ] add cognitions/concepts/definitions to _lib/entity-text.ts buildEmbedTextMeta (title x4 + body x1)
- [ ] add to _lib/read-entities.ts readEntityFields (if needed — defaults to id+title which is correct)

## Schema
- [ ] verify: patlib.sql has cognitions, concepts, definitions tables (already done)
- [ ] verify: vector DB reindex picks up new entity types

## Reindex
- [ ] bun run tools/reindex-vectors.ts --type cognitions --force
- [ ] bun run tools/reindex-vectors.ts --type concepts --force
- [ ] bun run tools/reindex-vectors.ts --type definitions --force
- [ ] bun run tools/reindex-vectors.ts --type terms --force

## Verification
- [ ] patlib_search --type cognitions --query "knowledge" returns COG.* entities
- [ ] patlib_search --type concepts --query "abstract" returns CON.* entities
- [ ] patlib_search --type terms --query "opencode" returns TERM.* entities
- [ ] patlib_vector_search --query "computer science" returns COG.COMPUTER.SCIENCE in top 5
