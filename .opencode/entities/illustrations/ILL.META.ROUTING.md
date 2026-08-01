---
id: ILL.META.ROUTING
title: "Entity Routing — Prefix Maps File to Table to Directory"
source: PROT.META.IDENTITY
summary: "Walkthrough of ID prefix routing: how PAT.NEW.PATTERN routes to .opencode/patterns/PAT.NEW.PATTERN.md and the patterns DB table, and how validation tools enforce the mapping."
illustration: "A new entity PAT.NEW.PATTERN routes to .opencode/patterns/ directory and the patterns DB table via its PAT. prefix. Validation tools check prefix matches directory, frontmatter id matches filename, and required fields exist."
illustrates: [SPEC.ENTITY.ROUTING.TABLE]
tags: routing,walkthrough,entity,prefix,validation
related: [REF.META.DATA.STRATUM, REF.META.NAMING.SCHEMA, PROT.PERSON.SCHEMA]
---
## Context

A new entity `PAT.NEW.PATTERN` needs to be created. The routing protocol determines where the file goes, which DB table stores it, and how validation confirms correctness.

## Routing table excerpt

| Prefix | Directory | DB table |
|--------|-----------|----------|
| `PAT` | `.opencode/patterns/` | `patterns` |
| `PROT` | `.opencode/protocols/` | `protocols` |
| `TERM` | `.opencode/terms/` | `terms` |
| `ILL` | `.opencode/illustrations/` | `illustrations` |
| `PER` | `.opencode/entities/persons/` | `persons` |

## Walkthrough

### Step 1: ID determines storage

The entity ID `PAT.NEW.PATTERN` has first segment `PAT`. The route table maps:
- Directory → `.opencode/patterns/`
- DB table → `patterns`
- File → `.opencode/patterns/PAT.NEW.PATTERN.md`

### Step 2: Validation tool checks

The validation tool runs five checks:

| Check | What it verifies | Example for PAT.NEW.PATTERN |
|-------|------------------|---------------------------|
| Prefix matches directory | File in `patterns/` directory has `PAT.*` ID | `PAT.NEW.PATTERN` in pattern path |
| ID matches regex | Segments uppercase, dot-separated, no chars outside `[A-Z0-9.]` | `PAT.NEW.PATTERN` passes `[A-Z][A-Z0-9]*(\.[A-Z][A-Z0-9]*)+` |
| Required frontmatter present | Fields per entity type | `id:`, `title:`, `summary:`, `principle:`, `tags:` |
| No orphan DB records | Every DB entry has a matching file | `SELECT id FROM patterns` matched against disk files |
| No duplicate IDs | No other `PAT.NEW.PATTERN` in any directory | `PAT.NEW.PATTERN` unique across all entity types |

### Step 3: Frontmatter as source of truth

The file frontmatter is the authoritative source. The DB is a read-only derived cache:

```yaml
---
id: PAT.NEW.PATTERN
title: "New Pattern — Applies the Convention"
source: assembler
summary: "One-sentence description of the pattern."
principle: "The governing design principle."
enforcement: Convention
tags: [new, pattern, example]
status: draft
priority: 3
---
```

If the file is deleted, `write-sync` removes the DB entry. If the file is renamed, the DB updates on the next sync. The file always wins.

### Step 4: Cross-reference validation

Other entities reference `PAT.NEW.PATTERN` by full ID. The validation tool confirms every cross-reference resolves to a valid entity, regardless of which entity type holds the target. A `PROT.*` entity can reference a `PAT.*` entity, and vice versa.

## Key insight

The prefix is the single source of routing truth. A file's directory, its DB table, and its validation rules all derive from the first three characters of the ID. This makes routing deterministic — given an ID, the storage location and validation rule set are computable without reading any configuration.

## See also

- `SPEC.ENTITY.ROUTING.TABLE` — the routing protocol this illustrates
- `REF.META.NAMING.SCHEMA` — naming convention for prefix, domain, subject, aspect
- `REF.META.DATA.STRATUM` — the four strata; routing operates at the entity stratum
- `REF.META.ENTITY.DUALITY` — bivalent entity; routing extends to arbitrary depth
