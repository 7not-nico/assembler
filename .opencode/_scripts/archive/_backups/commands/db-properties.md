---
description: Define YAML frontmatter fields per entity type for a DB workflow project
---

Properties for `$ARGUMENTS`

Reference — common fields across existing projects:
- id (required): unique identifier, UPPERCASE dot-separated
- title (required): human-readable name
- summary: one-line description
- tag (singular): inline scalar stays on entries table
- tags (plural array): signals own normalized table, each tag is one row with `ids` column
- related (singular scalar): inline reference to another entry ID
- related (plural array): signals own normalized table

1.  Review the entity manifest from `/db-entities` (`.opencode/manifests/entities.md`)
2.  For each entity type, define YAML fields:
    - Required fields: id, title
    - Optional common fields: summary, tag, tags, related, related
    - Type-specific fields (e.g., argument for commands, symptoms for scenarios)
3.  Mark each field: name, type (string / array / boolean), required or optional
4.  Mark plural array fields for their own normalized table
5.  Output manifest.

Conventions:
- YAML keys are always singular
- Plural array values signal their own normalized table
- Each normalized table: one row per value, `ids` TEXT column stores comma-separated parent entry IDs

Write output to `{project}/.opencode/manifests/properties.md`:

```yaml
types:
  $FOLDER_NAME:
    fields:
      - name: $FIELD_NAME
        type: string|array|boolean
        required: true|false
        own-table: true|false
```
