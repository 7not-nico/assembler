---
id: ILL.SCHEMA.MAP
title: "Polymorphic Junction — One Table for All Entity Cross-References"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of the polymorphic junction pattern: a single entity_terms table links any entity type to any term via (entity_type, entity_id, term_id) tuple."
illustration: "A single entity_terms table stores links between patterns and terms, protocols and terms, and illustrations and terms using (entity_type, entity_id, term_id) polymorphic key. Query by entity_type filters to the relevant domain."
illustrates: [REF.SCHEMA.JUNCTION.DISCRIMINATOR]
tags: schema,walkthrough,junction,discriminator,polymorphic
related: [PROT.SCHEMA.AUGMENT, REF.SCHEMA.DATABASE.OWNERSHIP]
---
## Rationale

Patlib entities reference terms across multiple entity types (patterns, protocols, illustrations). Rather than one junction table per pair, a single `entity_terms` table handles all cross-entity references via a discriminator column.

## The problem

Without a polymorphic junction, each entity type pair needs its own table:

```
pattern_protocols    pattern_terms       protocol_illustrations    ...
pattern_id           pattern_id          protocol_id
protocol_id          term_id             illustration_id
```

A new entity type requires a new junction table. Querying all references to a term requires N queries across N tables.

## The solution: discriminator column

A single table uses `entity_type` as a discriminator:

```
entity_terms
  entity_type   TEXT  ← 'pattern', 'protocol', 'illustration'
  entity_id     TEXT  ← PAT.ID, PROT.ID, ILL.ID
  term_id       TEXT  ← TERM.ID
  PRIMARY KEY (entity_type, entity_id, term_id)
```

## Walkthrough

### Step 1: Insert references

Three entity types reference `CON.ABSTRACTION`:

```sql
INSERT INTO entity_terms (entity_type, entity_id, term_id) VALUES
  ('pattern',    'REF.META.DATA.STRATUM',  'CON.ABSTRACTION'),
  ('protocol',   'SPEC.ENTITY.ROUTING.TABLE', 'CON.ABSTRACTION'),
  ('illustration', 'ILL.META.STRATUM.MAP',  'CON.ABSTRACTION');
```

### Step 2: Query by term

Find all entities referencing a term:

```sql
SELECT entity_type, entity_id FROM entity_terms WHERE term_id = 'CON.ABSTRACTION';
-- Returns: pattern:REF.META.DATA.STRATUM, protocol:SPEC.ENTITY.ROUTING.TABLE, illustration:ILL.META.STRATUM.MAP
```

### Step 3: Query by entity

Find all terms referenced by a specific entity:

```sql
SELECT term_id FROM entity_terms
WHERE entity_type = 'pattern' AND entity_id = 'REF.META.DATA.STRATUM';
```

### Step 4: Add a new entity type

Adding a new entity type (e.g., `apologia`) requires zero new junction tables:

```sql
INSERT INTO entity_terms (entity_type, entity_id, term_id) VALUES
  ('apologia', 'APO.SKILL.DERIVATION', 'IDENTITY.SKILL');
```

The schema stays the same. Only the `entity_type` discriminator value changes.

## Discriminator values

| entity_type | Refers to table |
|-------------|----------------|
| `pattern` | `patterns` |
| `protocol` | `protocols` |
| `term` | `terms` |
| `illustration` | `illustrations` |
| `apologia` | `apologias` |

## Key insight

The discriminator column eliminates junction table proliferation. Adding a new entity type requires zero schema changes — just a new discriminator value. The PRIMARY KEY (entity_type, entity_id, term_id) guarantees uniqueness across all types. Cross-type queries use a single WHERE clause instead of UNION across multiple tables.

## See also

- `REF.SCHEMA.JUNCTION.DISCRIMINATOR` — the polymorphic junction pattern this illustrates
- `PROT.SCHEMA.AUGMENT` — additive-only migration; discriminator values are additive
- `REF.SCHEMA.DATABASE.OWNERSHIP` — database schema governance
- `PROT.TERM.SCHEMA` — flat hierarchy via related links; complement to junction
