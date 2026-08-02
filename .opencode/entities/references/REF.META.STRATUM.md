---
id: REF.META.STRATUM
title: Stratum — Planes, Domains, Entities, and YAML Metadata
source: PROT.META.IDENTITY
summary: Data organizes into four strata — plane, domain, entity, property — each mapped to a filesystem or structural primitive.
ref: Every piece of data occupies a stratum. Planes group domains; domains contain entities; entities carry properties expressed as YAML.
related: []
tags: [architecture, data-model, plane, domain, entity, metadata, yaml]
---

Data organizes into four layers. Each addresses the one below.

## The four strata

| Stratum | Filesystem primitive | Role |
|---------|---------------------|------|
| Plane | Directory of directories | Groups related domains |
| Domain | Directory | Contains entities |
| Entity | `.md` file | Named object with metadata |
| Property | YAML (frontmatter/backmatter) | Attributes of the entity |

### Plane

A plane is a meta-domain — a grouping layer above domains. It names the abstraction level. Multiple domains within the same plane share schema shape and validation rules.

Planes are optional. A project may have entities directly in domains with no plane layer.

Plane → domain → entity follows the recursive structure: a plane IS a domain (it contains entities called domains), and a domain IS a plane when its own entities are domains. Formalized in `PROT.META.ENTITY.DUALITY`.

### Domain

A domain is a directory. Its name IS the domain name. Every `.md` file directly inside it is an entity belonging to that domain. Subdirectories within a domain are either nested domains (if the project uses Bivalent Entity recursion) or unrelated content.

The domain establishes the namespace for entity IDs.

### Entity

An entity is a file. Its existence in a domain directory IS its membership in that domain.

Entities are the unit of reference. Cross-entity links use the entity's ID. Filename and title serve navigation convenience only.

### Property

Properties are YAML metadata within the entity file. YAML provides three structural primitives that define all property types:

| YAML primitive | Property type | Description |
|---|---|---|
| Scalar | Atomic value | A single key-value pair |
| Sequence | Multi-value | An ordered list of values |
| Mapping | Structured property | Nested key-value fields |

Frontmatter (opening `---`) stores entity-level metadata — identity, classification, references. Backmatter (trailing `---`) stores relational metadata — sources, tags, notes.

## Rules

1. **Four strata, fixed order** — plane groups domains. Domain contains entities. Entity carries properties. Each stratum addresses the one below it.

2. **Planes are optional; domains exist at every entity layer** — every entity file sits in a domain directory. The plane layer exists only when domains need grouping.

3. **The `id:` field in frontmatter is the entity's canonical identifier** — filename is a human navigation convenience.

4. **YAML is the only metadata language for entity properties** — all properties use YAML syntax within the entity file.

5. **Frontmatter for identity; backmatter for relations** — frontmatter encodes what the entity IS; backmatter encodes how the entity relates to others.

6. **One primitive per property** — each property uses exactly one YAML primitive type: scalar, sequence, or mapping.

## Applicability

Every AMANDA project storing data as files with YAML metadata. This pattern defines the data substrate for all other patterns.

## See also

- `ILL.META.STRATUM.MAP` — concrete walkthrough through all four strata
- `PROT.META.ENTITY.DUALITY` — recursion: entities become domains, domains become planes
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix determines domain and table routing
- `PROT.SCHEMA.COLON.QUOTING` — YAML frontmatter constraint
- `PROT.META.DOMAIN.DIRECTORY` — domain extraction and lifecycle
- `PROT.META.PROJECT.TOPOLOGY` — metadata-first principle; this pattern formalizes it
- `IDENTITY.YAML` — YAML metadata stratum identity
