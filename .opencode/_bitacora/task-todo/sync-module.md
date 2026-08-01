# Sync module — cognitions, concepts, definitions

**Maxim refs:** MAX.KNOWLEDGE.CLASSIFICATION, MAX.DRY (one parser), MAX.CATALYST.FOR.CHANGE  
**Protocol refs:** PROT.COGNITION.SCHEMA, X, X

## Tasks
- [ ] add parseCognitionFile() to _lib/sync.ts
- [ ] add parseConceptFile() to _lib/sync.ts
- [ ] add parseDefinitionFile() to _lib/sync.ts
- [ ] add COGNITIONS_DIR, CONCEPTS_DIR, DEFINITIONS_DIR to _lib/paths.ts
- [ ] wire into syncAll(): cognitions block, concepts block, definitions block

## Verification
- [ ] syncAll("cognitions") — 0 items, no crash
- [ ] syncAll("concepts") — 0 items, no crash
- [ ] syncAll("definitions") — 0 items, no crash
- [ ] after terms classify: sync picks up COG/CON/DEF rows
