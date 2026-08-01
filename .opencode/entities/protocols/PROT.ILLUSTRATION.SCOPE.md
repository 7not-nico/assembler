---
id: PROT.ILLUSTRATION.SCOPE
title: "Illustration Cross-Reference Scope — Junction Table as Authoritative Link"
source: NEX.META.PROPOSAL
summary: "Illustration-to-entity relationships populate the illustration_entities junction table via the illustrates: frontmatter field. The junction table is the single authoritative cross-reference. Manual ILL.* links in entity frontmatter or See also sections are excluded. Query uses patlib_illustrations MCP tool."
protocol: "The illustration_entities junction table at root scope is the authoritative cross-reference for illustration-to-entity relationships. The patlib_illustrations MCP tool provides indexed reverse lookup. Entity frontmatter related: fields exclude ILL.* references — the junction table provides the reverse link. Sync populates the junction table from illustrates: frontmatter on every illustration sync cycle."
enforcement: Formality
status: active
priority: 2
tags: [illustration, cross-reference, junction, scope, patlib, convention]
---

The `illustration_entities` junction table hosts all illustration-to-entity relationships. Entity frontmatter and See also sections exclude this link.

## Protocol

1. **Junction table is the authoritative cross-reference** — `illustration_entities(illustration_id, entity_id, entity_type)` stores every `illustrates:` link. Each illustration sync cycle rebuilds this table from current frontmatter. The junction is the single source of truth for which entities an illustration walks through.

2. **No manual `ILL.*` links in entity frontmatter or See also** — entity `related:` frontmatter fields exclude `ILL.*` IDs. Entity `## See also` sections omit `ILL.*` entries. The junction table provides this relationship — inline duplication creates two authoritative sources.

3. **Exception for illustration files themselves** — illustration `## See also` sections list the entities they illustrate (cognitions, concepts, definitions, terms, patterns, protocols, maxims). This is required per `PROT.ILLUSTRATION.SCHEMA` body convention. The forward link (illustration → entity) lives in the illustration file. The reverse link (entity → illustration) lives only in the junction table.

4. **Query via `patlib_illustrations` MCP tool** — reverse lookup uses `patlib_illustrations` with filters for `entity_id`, `illustration_id`, and `entity_type`. The tool queries the `illustration_entities` junction table with indexed lookups. Direct SQL against the junction table is permitted for batch analysis.

5. **Sync populates the junction table** — `write-sync --type illustrations` reads `illustrates:` from every illustration file, deletes stale junction rows, inserts fresh rows. Run after any illustration create, edit, or rename to keep the cross-reference current.

## Gotchas

- Entity `related:` contains `ILL.*` ID: Remove the `ILL.*` link — the junction table carries this relationship (`related:` field in entity frontmatter has `ILL.` prefix value)
- Entity `## See also` lists an illustration: Remove the illustration entry — the junction table carries the reverse link (See also section contains `ILL.*` link)
- Illustration missing from junction table: Run `write-sync --type illustrations` to rebuild the junction table (`patlib_illustrations` returns empty for an entity known to have illustrations)
- Stale junction row after rename: Sync rebuilds from current `illustrates:` — stale rows are deleted on write-sync (Entity ID changed; `illustration_entities` still holds old ID)

## Enforcement

`audit-tool` scans entity `related:` frontmatter fields. `ILL.*` references flagged as cross-reference scope violations. Exception: illustration files carry `ILL.*` to `ILL.*` references freely — those are in-domain links.

## See also

- `PROT.ILLUSTRATION.SCHEMA` — illustration schema, body convention, content rules
- `REF.SCHEMA.JUNCTION.DISCRIMINATOR` — polymorphic junction pattern implemented by `illustration_entities`
- `ILL.ILLUSTRATION.CREATE.FILE` — walkthrough creating an illustration with `illustrates:` linkage
