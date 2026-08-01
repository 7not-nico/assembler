---
id: REF.META.ROOT
title: Entity Scope Root — Patlib Entities Belong at Root Only
source: PROT.META.IDENTITY
summary: "All patlib entity directories (patterns, terms, protocols, abstractions, apologias, rules, skills, commands) live at assembler root .opencode/. Subprojects reference root entities; hosting these directories excluded."
ref: Every patlib entity directory — patterns/, terms/, protocols/, abstractions/, apologias/, rules/, skills/, commands/ — resides at assembler/.opencode/. Subprojects consume root entities via reference (patlib_search, read-selection); entity-type directories from this list excluded at subproject level.
related: []
tags: [architecture, entity, scope, root, subproject, convention, patlib]
---

All patlib-type directories live at root. Subprojects reference; hosting excluded.

## Rules

1. **Root hosts all entity directories** — `assembler/.opencode/` contains patterns/, terms/, protocols/, abstractions/, apologias/, rules/, skills/, commands/. Subprojects reference these via `patlib_search` or `read-selection`.

2. **Subprojects exclude entity directories** — subproject `.opencode/` hosts tools/, lib/, plugins/, schemas/, and project-specific directories only. No entity-type directory from rule 1 appears in subproject `.opencode/`.

3. **Project-specific context uses tags** — when a root-level pattern or term needs subproject-specific nuance, extend with tags (`tag: medcodes`); duplication in a subproject entity file excluded. Root entities carry cross-project context; tags scope consumption.

4. **Subproject requests new entity at root** — when a subproject needs a pattern, term, or protocol absent from patlib, create it at root scope with appropriate source and tags. The subproject hosts it at root; local hosting excluded.

## Applicability

Any AMANDA subproject under `assembler/one-timers/`. Entity scope is evaluated at project bootstrap and when extending or creating patlib content.

Excluded for project-specific data schemas, tool config, and domain DBs — these live per-project; root hosting excluded.

## See also

- `PROT.META.IDENTITY` — protocol scope rule; Entity Scope Root extends scope constraint to all patlib entity types
- `PROT.LIB.DIRECTORY.LAYER` — root `_lib/` vs subproject `lib/` distinction; parallel scope pattern for lib modules
- `PROT.META.ENTITY.DUALITY` — entity nesting structure; Entity Scope Root governs placement across projects
- `PROT.META.DOMAIN.DIRECTORY` — domain boundaries; Entity Scope Root sets the root-container boundary
- `guide-architecture` skill — layer decision procedure; Entity Scope Root constrains entity placement step
