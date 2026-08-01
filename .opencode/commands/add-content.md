---
description: Scaffold a new content .md file for any entity type in a bootstrapped DB project
subtask: true
---

Scaffold a content file for `$ARGUMENTS`

1. Ensure prerequisites — `.opencode/manifests/entities.md` and `properties.md` must exist
2. Read `.opencode/manifests/entities.md` — extract entity types (folder names, example IDs)
3. Read `.opencode/manifests/properties.md` — extract field definitions per entity (required vs optional, scalar vs array)
4. Use `question` tool: which entity type to create?
5. Use `question` tool: what is the entity ID? Derive filename from ID (lowercase, segments joined with hyphens: `TC.ENTRY.BOOTSTRAP` → `entry-bootstrap.md`)
6. Use `question` tool for each required field — name, type. Mark `own-table: true` fields as nullable
7. Use `question` tool for tags — YAML inline array, optional
8. Write file to `{entity_folder}/{filename}.md` following conventions — file name lowercase hyphen-separated, tags as `tags: [tag1, tag2]`, optional fields omitted if no value, scalar fields on main table, array fields in normalized subtable

**Frontmatter pattern**

```
---
id: {ID}
title: {TITLE}
{field_name}: {field_value}
---
```
