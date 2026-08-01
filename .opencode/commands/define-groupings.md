---
description: Define optional entity groupings that share directory, table routing, and field profiles
subtask: true
---

Define groupings for `$ARGUMENTS`

1. Review domain manifest from `/db-domain` (`.opencode/manifests/domain.md`)
2. Use question tool: does this project have entity groupings — categories where entities share a directory, a DB table, and a field set?
3. If groupings exist, use question tool for each: name, description, list of groups within it
4. Use question tool for each group: id, label, directory path, DB table name, entity prefixes, shared field list
5. If no groupings exist, output `groupings: none` — entities will be flat under `/db-entities`
6. Follow conventions — each group has its own directory and DB table, entity prefixes determine routing at sync time, `shared_fields` lists columns common to all entities in the group (excluding `id` and `title`)
7. Output manifest to `{project}/.opencode/manifests/groupings.md`

**Output**

```yaml
grouping: $GROUPING_NAME
description: $ONE_LINE_DESCRIPTION
groups:
  - id: $GROUP_ID
    label: $HUMAN_LABEL
    description: $ONE_LINE_PER_GROUP
    directory: $RELATIVE_DIRECTORY_PATH
    table: $DB_TABLE_NAME
    prefixes: [$PREFIX1, $PREFIX2]
    shared_fields: [$FIELD1, $FIELD2]
    id_format: $ID_PATTERN_DESCRIPTION
    file_naming: $FILE_NAMING_CONVENTION
```
