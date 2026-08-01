---
description: Identify entity types and define content folders for a DB workflow project
subtask: true
---

Identify entities for `$ARGUMENTS`

1. Review domain manifest from `/db-domain` (`.opencode/manifests/domain.md`)
2. Use question tool to list entity types: what real-world concepts earn their own `.md` files?
3. Use question tool for each type: folder name (one word, plural, descriptive), description, example filename
4. Use question tool to validate: does each type earn its own folder or is it a property of another?
5. Follow conventions — folder names one word plural descriptive, file names lowercase hyphen-separated max 2 segments, entity ID format `FOLDER.GENERAL.SPECIFIC` in UPPERCASE dot-separated max 3 segments
6. Output manifest to `{project}/.opencode/manifests/entities.md`

**Output**

```yaml
entities:
  - folder: $FOLDER_NAME
    description: $ONE_LINE_DESCRIPTION
    example-file: $EXAMPLE.md
    example-id: $FOLDER.EXAMPLE.ID
```
