---
id: ILL.META.SCOPE
title: "Entity Scope Decision — Root vs Subproject Entity Placement"
source: PROT.META.IDENTITY
summary: "Walkthrough of deciding where a new term belongs when a subproject needs it — root patlib or local scope. Applies Entity Scope Root rules to a concrete scenario."
illustration: "A medcodes subproject needs a new term ICD.CODE. Entity Scope Root rules say create at root with tags:medcodes; local hosting excluded."
illustrates: [REF.META.ENTITY.ROOT]
tags: entity,scope,walkthrough,root,subproject,decision
related: [REF.META.ENTITY.DUALITY, REF.LIB.DIRECTORY.LAYER]
---
## Rationale

Without Entity Scope Root, subprojects can create their own entity directories, duplicating root-level content or creating ambiguous ownership. Root-scope hosting with tags for project-specific context eliminates fragmentation while keeping entities discoverable across all projects. Four rules govern placement: root hosts all entity directories, subprojects exclude them, tags scope consumption, and new entities are created at root.

A `medcodes` subproject under `one-timers/` needs a new term `TERM.ICD.CODE` to define ICD code structure. The pattern `REF.META.ENTITY.ROOT` defines four rules governing entity placement. This walkthrough applies each rule to the concrete scenario.

Files involved:
- `one-timers/medcodes/.opencode/` — the subproject directory
- `.opencode/terms/` — root-level entity directory

## Walkthrough

### Step 1: Check rule 1 — root hosts all entity directories

Rule 1 states `assembler/.opencode/` contains terms/ at root. The subproject `medcodes/.opencode/` is inspected:

```
one-timers/medcodes/.opencode/
├── tools/          ✓
├── lib/            ✓
├── plugins/        ✓
└── schemas/        ✓
```

No `terms/` directory in the subproject. Root `.opencode/terms/` already exists with 74 term files. The term belongs at root.

### Step 2: Check rule 2 — subproject excludes entity directories

If the subproject had a `terms/` directory, it would violate rule 2. The agent verifies the exclusion:

```
$ ls one-timers/medcodes/.opencode/terms/
ls: term directory absent
✓ — no entity directory in subproject
```

### Step 3: Check rule 3 — use tags for project-specific context

The term `TERM.ICD.CODE` is specific to medical coding. It may also serve other projects. Rule 3 says create at root with a `medcodes` tag:

```
id: TERM.ICD.CODE
title: ICD Code — International Classification of Diseases Identifier
tags: medcodes,classification,health
```

The tag `medcodes` scopes consumption. A `ludoteca` subproject querying for game-related terms filters them out; a `medcodes` query finds them.

### Step 4: Check rule 4 — subproject requests new entity at root

The agent creates the term at root scope following standard workflow:

1. Check patlib for existing `TERM.ICD.CODE` — absent
2. Create `.opencode/terms/TERM.ICD.CODE.md` with backmatter
3. Run `write-sync --type terms` — 75 terms now

The subproject gains access immediately via `read-selection --type terms --tag medcodes`.

### Step 5: Alternative scenario — protocol placement

Same decision for a new protocol `PROT.MEDCODES.FORMAT`:

```
follows rule 1: root/.opencode/protocols/
follows rule 3: tags: medcodes
follows rule 4: created at root, sourced from medcodes work
```

The decision outcome is identical regardless of entity type (pattern, term, protocol).

## Key insight

Entity Scope Root prevents entity fragmentation across subprojects. The decision reduces to: cross-project knowledge lives at root with tags; subproject-specific data lives in subproject schemas. Every entity type follows the same four rules — patterns, terms, protocols, abstractions all at root.

## See also

- `REF.META.ENTITY.ROOT` — the entity scope pattern this illustrates
- `REF.META.ENTITY.DUALITY` — entity nesting structure
- `REF.LIB.DIRECTORY.LAYER` — parallel scope pattern for lib modules
- `REF.META.DOMAIN.DIRECTORY` — domain boundaries
- `guide-architecture` skill — layer decision procedure
