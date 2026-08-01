# Entity Type Reference

## Required fields per type

Five principle entity types with frontmatter and body conventions:

**Maxim** — `MAX.*` prefix. Required frontmatter: id, title, source, summary, principle, enforcement, tags, status, priority. Uses `principle:` field. Optional: related.

**Specification** — `SPEC.*` prefix. Backmatter format. Required: id, title, source, summary, tags, status. Optional: related, reference. No `principle:` or `protocol:` field.

**Protocol** — `PROT.*` prefix. Required frontmatter: id, title, source, summary, protocol, enforcement, status, priority, tags (min 3). Uses `protocol:` field. Optional: related, reference.

**Pattern** — `PAT.*` prefix. Required frontmatter: id, title, source, summary, principle, enforcement, tags, status, priority. Uses `principle:` field. Optional: related.

**Rule** — `RUL.*` prefix. YAML format in `rules/yamls/`. Required: id, title, source, tags. Optional: related, category.

**Identity** — `IDENTITY.*` prefix. Backmatter format. Required: id, title, source, group, ring, naming, tags. Optional: related, reference.

## Enforcement values

`Convention`, `Tool`, `Review`, `Code review` — mapped per entity type in schema seed files. Ring mapping defined per type in schema seeds.
