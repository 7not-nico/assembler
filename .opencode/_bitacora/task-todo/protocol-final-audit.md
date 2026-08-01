# Protocol audit — final sweep

## Updated (8 total)
- [x] PROT.SEARCH.EMBEDDING — added cognitions/concepts/definitions to entity type table
- [x] PROT.TOOL.MODEL — rule 8: TRNS naming exception for reindex-*
- [x] REF.SCHEMA.DATABASE.PRAGMA — added busy_timeout=5000 as standard PRAGMA
- [x] PROT.META.DOMAIN — added COGNITION, CONCEPT, DEFINITION, ILLUSTRATION, SEARCH to canonical domain list
- [x] X — added cognitions, concepts, definitions to illustrates field
- [x] PROT.ILLUSTRATION.CROSSREF.SCOPE — same addition in crossref list
- [x] PROT.TERM.SCHEMA — added COG.* to valid external sources (was CON/DEF only)
- [x] PROT.META.IDENTITY — added cognitions, concepts, definitions to entity type list

## Verified
- [x] spec_audit 100/100 on all 8
- [x] entity_audit PASS on all
- [x] synced to patlib.db

## Cross-check with qalc
- [x] 8 protocols updated out of 35 total = 22.9%
