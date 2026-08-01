---
id: ILL.META.FORMAT
title: "TOON Format — Batch Entity Creation Walkthrough"
source: PROT.META.IDENTITY
summary: "Walkthrough of creating a ludoteca batch entity file using TOON format: refs section in tabular form, entities in list-object form, dependency ordering by section."
illustration: "A new game entry uses TOON format: refs[2] declares developers and publishers, entities[1] defines the game with platform array, notes and urls follow. Sections appear in dependency order."
illustrates: [NEX.META.TOON.ORCHESTRATION]
tags: ludoteca,walkthrough,toon,batch,entity,format
related: [NEX.META.TOON.ORCHESTRATION]
---
## Rationale

Batch entity creation needs a structured file format where sections appear in dependency order — refs before entities, entities before notes and urls — so the consumer never encounters a forward reference. Each section maps to a lib function call.

A new game entity needs to be added to ludoteca. The TOON format declares sections in dependency order: refs before entities, entities before notes and urls.

## Walkthrough

### Step 1: Declare references

References are reusable entities (developers, publishers, franchises) that entities reference:

```
refs[2]{type,name,country,status}:
  developer,Bungie,US,active
  publisher,"Microsoft Game Studios",US,active
```

Column names match `reference-write.ts` definitions. Array length `[2]` matches the row count.

### Step 2: Declare entities

Entities reference the refs by name. Multi-value fields use inline array syntax:

```
entities[1]:
  - type: game
    id: GAME.XBOX.HALO
    title: "Halo: Combat Evolved"
    platform[2]: Xbox,Xbox 360
    genre: "First-person shooter"
    year: 2001
    developer[1]: Bungie
    publisher[1]: "Microsoft Game Studios"
    composer[2]: Martin O'Donnell,Michael Salvatori
```

The `[N]` syntax after a field name declares the number of values. `platform[2]` means two platforms.

### Step 3: Add notes

Notes carry supplementary text. Each note has an id and a body:

```
notes[1]:
  - id: GAME.XBOX.HALO
    body: "First entry in the Halo franchise, released as an Xbox launch title."
```

### Step 4: Add URLs

URLs link external resources to the entity:

```
urls[1]:
  - id: GAME.XBOX.HALO
    urls[1]: https://en.wikipedia.org/wiki/Halo:_Combat_Evolved
```

### Complete file

```
refs[2]{type,name,country,status}:
  developer,Bungie,US,active
  publisher,"Microsoft Game Studios",US,active

entities[1]:
  - type: game
    id: GAME.XBOX.HALO
    title: "Halo: Combat Evolved"
    platform[2]: Xbox,Xbox 360
    genre: "First-person shooter"
    year: 2001
    developer[1]: Bungie
    publisher[1]: "Microsoft Game Studios"

notes[1]:
  - id: GAME.XBOX.HALO
    body: "First entry in the Halo franchise."

urls[1]:
  - id: GAME.XBOX.HALO
    urls[1]: https://en.wikipedia.org/wiki/Halo:_Combat_Evolved
```

## Format rules in practice

| Rule | In this file |
|------|-------------|
| Sections in dependency order | refs → entities → notes → urls |
| Refs use tabular arrays | `[2]{type,name,country,status}` with two rows |
| Entities use list-object format | Hyphen-prefixed objects with typed fields |
| String quoting per TOON spec | `"Microsoft Game Studios"` quoted (contains space) |
| Array length matches count | `platform[2]` has two values |

## Key insight

The TOON format decouples section concerns: refs are tabular (data rows), entities are object-oriented (typed fields), notes and urls are associative (id + content). The section order eliminates forward references — every ref appears before any entity references it.

## See also

- `NEX.META.TOON.ORCHESTRATION` — the TOON format pattern this illustrates
- `NEX.META.TOON.ORCHESTRATION` — TOON orchestration protocol
