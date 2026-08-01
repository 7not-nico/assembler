# Entity Classification Report

## Encyclopedia Distribution

Per MAX.KNOWLEDGE.CLASSIFICATION — 3 groups, ordinal layers.

| Group | Layer | Type | Count | Examples |
|-------|-------|------|-------|---------|
| Encyclopedic | 1st | Cognition (COG) | 16 | MATH, COMPUTER.SCIENCE, ACCOUNTING, LINGUISTICS |
| Encyclopedic | 2nd | Concept (CON) | 23 | ABSTRACT, BOUNDED.CONTEXT, DECOUPLING |
| Encyclopedic | 2nd | Definition (DEF) | 2 | ORGANELLE, DX7 |
| Encyclopedic | 3rd | Term (TERM) | 33 | MCP, PLAYWRIGHT, AUDIT.*, PLANE.* |
| Architectonic | 1st | Maxim (MAX) | 18 | CODE.LAYERS, KNOWLEDGE.CLASSIFICATION, DRY |
| Architectonic | 3rd | Protocol (PROT) | 36 | COGNITION.IDENTITY, TOOL.CLASSIFICATION |
| Architectonic | 3rd | Pattern (PAT) | 7 | LLM.SPECIFICATION, META.LAYER.TRIGGER |
| Architectonic | 4th | Nexus (NEX) | 12 | — |
| Architectonic | 5th | Illustration (ILL) | 81 | — |
| Architectonic | 5th | Reference (REF) | 34 | — |
| Chronicle | 1st | Person (PER) | 8 | — |
| Chronicle | 2nd | Apologia (APO) | 1 | — |
| Chronicle | 2nd | Investigation (INV) | — | — |
| Other | — | Skill (SKL) | 57 | — |
| Other | — | Rule (RUL) | 38 | — |
| Other | — | Command (CMD) | 27 | — |
| Other | — | Abstraction (ABS) | 3 | — |
| Other | — | Linguistics (LNG) | 1 | — |

## Migrations This Session

| Type | Count | Details |
|------|-------|---------|
| COG moved from TERM | 7 | COMPUTER.SCIENCE, MATH, CONCURRENCY, PARALLELISM, LINGUISTICS, ACCOUNTING, VERBAL.REASONING, LOGICAL.OPERATORS, MACHINE.LEARNING, etc. |
| CON moved from TERM | 5 | ABSTRACT, ABSTRACTION, BOUNDED.CONTEXT, DECOUPLING, HORIZONTAL.PARTITIONING, VERTICAL.PARTITIONING, TOOLCLASS.AUTOMATON, INHERENCE.ASCRIBED, etc. |
| DEF moved from CON | 1 | DX7 (physical synthesizer) |
| CON moved from COG | 2 | SQLITE.STORAGE.CLASSES, SUBJECT.OBJECT.VERB |
| PROT moved from PAT | 1 | LIB.CONTRACT.ENFORCEMENT (had protocol: field) |
| Dropped | 2 | OPENCODE.THOUGHT (orphan), NIIF (no cross-refs) |

## Protocol Updates This Session

| Protocol | Update |
|----------|--------|
| PROT.SEARCH.EMBEDDING | Added COG/CON/DEF to entity type table |
| PROT.TOOL.MODEL | Rule 8: TRNS naming exception |
| REF.SCHEMA.DATABASE.PRAGMA | Added busy_timeout=5000 |
| PROT.META.DOMAIN | Added missing domains |
| X | Added new types to illustrates |
| PROT.ILLUSTRATION.CROSSREF.SCOPE | Same in crossref list |
| PROT.TERM.SCHEMA | Added COG.* as valid external source |
| PROT.META.IDENTITY | Added COG/CON/DEF to entity list |
| REF.META.NAMING.SCHEMA | Added missing prefixes |

## New Entities Created This Session

| Entity | Type |
|--------|------|
| MAX.BATCH.PROCESS | Maxim |
| MAX.SYNC.STALE.CLEANUP | Maxim |
| MAX.ENTITY.RECLASSIFY | Maxim |
| RUL.CODE.SIGNATURE | Rule |
