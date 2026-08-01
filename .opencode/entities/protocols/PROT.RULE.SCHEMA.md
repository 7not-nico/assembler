---
id: PROT.RULE.SCHEMA
title: "Rule Identity — Metadata and Body Protocol"
source: PROT.META.IDENTITY
summary: "Rule entity metadata fields (id, title, group, tags, category, related) and paired body instruction file conventions. Rules belong to the Architectonic group, Ring 0 per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY."
protocol: "Every rule YAML under rules/yamls/ has id, title, group, tags (min 3). Source field is absent — group encodes the organizational parent, related encodes maxim grounding. No precedes field — rule YAML stores metadata only. Body paired as rules/{name}.md with bold title line and Scope: line."
enforcement: Formality
status: active
priority: 2
tags: [rule, entity, identity, schema, convention, architecture, metadata]
reference: SPEC.MAXIM.LINE.JUNCTION
---

By SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY, rules are Architectonic Ring 2 entities. Tool (Ring 0) precedes Command/Skill (Ring 1) precedes Rule (Ring 2). The rule YAML stores metadata only — ontological vectors (precedes) are not stored in rule metadata.

## Protocol

### Metadata — frontmatter fields

Rule YAML requires six metadata fields: `id` (required, `RUL.{UPPERCASE.SEGMENTS}`), `title` (required, display name matching `rules/{name}.md` bold line), `group` (required, `assembler` for parent rules; parent `RUL.*` ID for child rules), `tags` (required, inline array `[tag1, tag2, tag3]`, minimum 3), `category` (optional, `principle`, `method`, `derivation`, `convention`), `related` (optional, `MAX.*` for parent rules; optional for child rules).

### Metadata rules

- `source` is absent — rules do not use the source field. `group` encodes the organizational parent. Owner maxim grounding is expressed via `related` on parent rules.
- `precedes` is absent — rule YAML stores metadata only. Ontological vectors (by which a rule may precede other entity types) are declared elsewhere.
- Parent rules (`group: assembler`) must have `related` pointing to a maxim entity (`MAX.*`) that grounds the rule's principle.
- Child rules (`group: RUL.*`) inherit maxim grounding through the parent chain — no need to repeat in their own `related`.
- `group` is the sole organizational parent mechanism. There is no separate `source` hierarchy.

### Body — instruction file

Every `rules/yamls/{name}.yaml` must have a paired `rules/{name}.md` instruction file with four elements: Title line (required, `**Title** — description` in imperative mood), Scope line (required, `Scope: {level}-level.` within first 3 lines), Composes with (optional, `Composes with {ENTITY.ID}` — cross-references), Body (optional, additional rule instructions in prose).

### Paired file convention

- `rules/yamls/{name}.yaml` is the authoritative patlib source — stores metadata for query.
- `rules/{name}.md` is the loaded instruction copy — stores human-readable rule text.
- A rule may exist in patlib without an instruction file. An instruction file without a YAML is invisible to query tools.
- Every YAML must have a corresponding `.md`. Every `.md` must have a corresponding YAML.

## Gotchas

- `source` field present in YAML: Remove — rules do not use source. Use `group` for parent, `related` for maxim. (Rule YAML contains `source: ...`)
- `precedes` field present in YAML: Remove — rule YAML stores metadata only. Precedes belongs in entity-level declarations. (Rule YAML contains `precedes: ...`)
- Missing `group` field: Add — `assembler` for parent, parent `RUL.*` ID for child. (YAML lacks group key)
- Parent rule without `related`: Add `related` with a maxim entity ID that grounds the rule's principle. (`group: assembler` but no `related: [MAX.*]`)
- Orphan YAML: Create the instruction file. (YAML without paired `.md`)
- Orphan .md: Create or request the YAML. (`.md` without paired YAML)
- Generic `group: writing`: Replace with proper parent rule ID — `RUL.WRITING.CONVENTION`, etc. (Group uses plain string instead of `RUL.*` ID)

## Enforcement

Code review. New rule YAML creation checks: (1) `id` matches RUL.* format, (2) `title` non-empty, (3) `group` present (assembler or RUL.*), (4) `tags` min 3, (5) no `source` field, (6) no `precedes` field, (7) parent rules have `related: [MAX.*]`, (8) corresponding `rules/{name}.md` exists.

## Applicability

All rule YAML files under `rules/yamls/` and their paired `rules/{name}.md` instruction files across all projects.

## See also

- `PROT.META.IDENTITY` — entity identity meta-protocol (metadata + body pattern)
- `PROT.MAXIM.SCHEMA` — maxim identity protocol
- `IDENTITY.RULE` — rule entity identity
- `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` — Architectonic group, Ring 0
- `SPEC.ENTITY.DISCERNIBILITY.SEGMENT` — ID segment progression (RUL.* prefix)
