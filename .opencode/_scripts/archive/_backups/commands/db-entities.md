---
description: Identify entity types and define content folders for a DB workflow project
---

Entities for `$ARGUMENTS`

Reference — content folders in existing projects:
- patlib: `patterns/`, `terms/`
- ludoteca: `games/`, `hacks/`, `emulators/`, `architectures/`
- nerdfont: `glyphs/`, `sets/`

1.  Review the domain manifest from `/db-domain` (`.opencode/manifests/domain.md`)
2.  List entity types — each is a real-world concept worth its own `.md` files
3.  For each type: folder name (one word, plural, descriptive), description, example filename
4.  Validate — does each type earn its own folder? Or is it a property of another?
5.  Output manifest.

Conventions:
- Folder names: one word, plural, descriptive
- File names: lowercase, hyphen-separated, max 2 segments
- ID format: `FOLDER.GENERAL.SPECIFIC` — UPPERCASE, dot-separated, max 3 segments (folder + file segments combined)

Write output to `{project}/.opencode/manifests/entities.md`:

```yaml
entities:
  - folder: $FOLDER_NAME
    description: $ONE_LINE_DESCRIPTION
    example-file: $EXAMPLE.md
    example-id: $FOLDER.EXAMPLE.ID
```
