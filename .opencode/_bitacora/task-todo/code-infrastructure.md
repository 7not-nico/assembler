# Code infrastructure — COG/CON/DEF entity type support

**Maxim refs:** MAX.KNOWLEDGE.CLASSIFICATION (entity groups → tables), MAX.DRY (one mapping), MAX.CATALYST.FOR.CHANGE (one file, verify)  
**Protocol refs:** PROT.SEARCH.EMBEDDING (entity text composition), REF.META.ENTITY.ROUTING (prefix→table)

## 5 files to update — one at a time, verify between

### [ ] 1. _lib/vector-query.ts — ENTITY_TYPES + entityTable()
- [ ] add "cognitions", "concepts", "definitions" to ENTITY_TYPES
- [ ] add cognitions→cognitions, concepts→concepts, definitions→definitions to entityTable()
- [ ] verify: entityTable("cognitions") returns "cognitions"
- [ ] verify: ENTITY_TYPES includes all 16 types

### [ ] 2. _lib/entity-text.ts — ENTITY_BODY_TABLES
- [ ] add cognitions, concepts, definitions to ENTITY_BODY_TABLES set
- [ ] verify: readEntityExtraCols("cognitions") returns body column
- [ ] verify: readEntityFields("cognitions") returns ["id", "title"]

### [ ] 3. _lib/mcp-types.ts — ENTITY_TYPES + ID_PREFIX_TO_ENTITY_TYPE
- [ ] add cognitions, concepts, definitions to ENTITY_TYPES
- [ ] add COG→cognitions, CON→concepts, DEF→definitions to ID_PREFIX_TO_ENTITY_TYPE
- [ ] verify: ID_PREFIX["COG"] === "cognitions"
- [ ] verify: TERM still maps to "terms"

### [ ] 4. tools/mcp-patlib-vector/index.ts — TYPE_SOURCE_DIRS
- [ ] add cognitions, concepts, definitions dirs
- [ ] verify: entitySourcePath resolves correctly

### [ ] 5. tools/mcp-patlib/index.ts — ENTITY_TYPES enum
- [ ] imports from _lib/mcp-types — verify auto-pickup
- [ ] if hardcoded, add new types

### Final verification
- [ ] initDB() — all 16 entity tables queryable
- [ ] reindex-vectors --type cognitions — 0 items, no crash
