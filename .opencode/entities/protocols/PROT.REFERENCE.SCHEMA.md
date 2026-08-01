---
id: PROT.REFERENCE.SCHEMA
title: "Reference Identity — Shared Reference Document Entity"
source: SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY
related: [IDENTITY.REFERENCE, REF.META.REFERENCE.AUTHORITY, IDENTITY.ILLUSTRATION]
summary: "REF.* entities are shared reference documents. One REF.* may be cited by many consumers via the reference: metadata field. No entity duplicates reference content that exists as a REF.*."
protocol: "REF.* entities are shared reference documents. Frontmatter uses id, title, source, summary, ref, tags. REF.* entities belong to the Composition group, Ring 3 per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY. Multiple entities may share the same reference via the reference: metadata field."
enforcement: Convention
status: active
priority: 2
tags: [reference, identity, entity, schema, citation, composition]
---

Reference entities provide expanded specification detail for protocols, conventions, terms, and other entity types. One REF.* entity serves many consumers — no entity duplicates reference content.

## Protocol

1. **Use REF.* ID prefix** — reference IDs follow `REF.{DOMAIN}.{TOPIC}`. Examples: `REF.PERSON.EVENT.TIMELINE`, `REF.META.REFERENCE.AUTHORITY`. REF.* entities are Composition group, Ring 3 per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY.

2. **Frontmatter stores identity and metadata** — required fields: id, title, source, summary, ref, tags. The `ref:` field holds the authoritative specification content.

3. **One REF.* serves many consumers** — any entity type may reference a REF.* entity via its `reference:` metadata field. The `reference:` field appears in frontmatter or backmatter depending on entity type convention. No entity duplicates reference content that exists as a REF.*.

4. **Body expands the ref field** — after the closing `---`, markdown body provides detailed protocol, schema, gotchas, enforcement, and applicability sections that expand on the `ref:` summary.

## Schema

### references table

Seven columns: `id` (TEXT PRIMARY KEY, REF.* ID), `title` (TEXT REQUIRED, display name), `body` (TEXT REQUIRED, markdown after frontmatter), `source` (TEXT, origin), `ref_text` (TEXT, the `ref:` field content), `tags` (TEXT, comma-separated), `related` (TEXT, comma-separated). Plus `created` and `modified` timestamps.

## Gotchas

- REF.* entity with no consumers: Check that at least one entity references this REF.* via the `reference:` field. Orphaned references accumulate without serving any entity (No entity's `reference:` field points to this REF.* ID)
- Duplicate reference content across entities: Extract the shared content to a REF.* entity and point all consumers via `reference:` (Two or more entities reproduce the same citation or specification inline)
- Missing `ref:` field: The `ref:` field is required — it is the authoritative specification content that consumers reference (Frontmatter lacks `ref:` key)
- REF.* entity with identical content to another REF.*: Merge into a single REF.* — references are shared, not duplicated (Two REF.* entities have the same or overlapping `ref:` content)

## Enforcement

`write-sync` reads `ref:` from frontmatter and stores it in the `ref_text` column. `read-validate` verifies frontmatter fields. `read-selection` lists REF.* entities by source or tag.

## Applicability

All REF.* entities across all projects. The protocol applies whenever an entity needs a shared, citable reference document.

## See also

- `IDENTITY.REFERENCE` — reference entity identity definition
- `REF.META.REFERENCE.AUTHORITY` — reference source authority (textbooks vs papers)
- `IDENTITY.ILLUSTRATION` — illustration entity (Ring 3 sibling in Composition group)
- `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` — Composition group, Ring 3 placement
