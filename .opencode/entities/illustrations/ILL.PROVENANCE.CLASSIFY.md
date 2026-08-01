---
id: ILL.PROVENANCE.CLASSIFY
title: "Provenance Classification — Inherent vs Ascribed Attributes"
source: PROT.META.DOMAIN
summary: "Walkthrough of classifying metadata attributes for a game entity into inherent (derived from entity existence) and ascribed (assigned by decision) categories."
illustration: "A game entity has 10 metadata attributes: platform and release year are inherent (scrapable from the entity); rating and genre are ascribed (require an assigner's decision). Each class determines collection strategy and failure mode."
illustrates: [REF.PROVENANCE.CLASSIFICATION]
tags: metadata,walkthrough,classification,provenance,inherent,ascribed
related: [TERM.INHERENT.ASCRIBED, MAX.CODE.DRY.PRINCIPLE]
---
## Rationale

A ludoteca game entry has multiple metadata attributes. Each attribute belongs to one of two provenance classes. The class determines how the attribute is collected, trusted, and maintained.

## Entity: GAME.XBOX.HALO

```
id: GAME.XBOX.HALO
title: "Halo: Combat Evolved"
platform: Xbox
year: 2001
genre: "First-person shooter"
developer: Bungie
publisher: "Microsoft Game Studios"
rating: "M" (Mature)
multiplayer: true
mod-support: false
```

## Walkthrough

### Step 1: Classify each attribute

| Attribute | Class | Rationale |
|-----------|-------|-----------|
| `id` | Inherent | Follows from game existence; no decision required |
| `platform` | Inherent | Published specification — scraper reads the disc label |
| `year` | Inherent | Published release date — authoritative from publisher |
| `developer` | Inherent | Credit in the game — scrapable from title screen |
| `genre` | Ascribed | Design decision — no label on the disc; assigner chooses |
| `publisher` | Inherent | Legal entity from published metadata |
| `rating` | Ascribed | Rating board decision (ESRB) — external assigner |
| `multiplayer` | Ascribed | Design feature — developer decides and documents |
| `mod-support` | Ascribed | Design decision — community support excluded; decision required |

### Step 2: Determine collection strategy

| Class | Natural collector | Tool |
|-------|------------------|------|
| Inherent | Scanner | `ludoteca_scrape_metadata` reads from authoritative source automatically |
| Ascribed | Convention engine | `ludoteca_assign_attribute` requires human or rule-based decision input |

### Step 3: Determine failure mode

| Class | Failure mode | Detection |
|-------|-------------|-----------|
| Inherent | Stale data | Source changes; scraper runs on old snapshot |
| Ascribed | Wrong decision | Assigner chooses incorrect value; scanner produces stale metadata |

### Step 4: Consequences of conflation

If `genre` (ascribed) is collected by scanner:
- Scanner reads the game executable and finds no genre label
- Returns null or guesses — produces stale metadata
- Downstream displays "Unknown" or incorrect genre

If `platform` (inherent) is collected by convention engine:
- Convention engine asks an assigner "what platform?"
- Assigner must type "Xbox" — decision metadata for a value that follows from entity existence
- Produces falsely automated metadata — the decision adds zero information

## Key insight

Inherent attributes change when the entity changes. Ascribed attributes change when the decision changes. Collecting an ascribed attribute by scanner produces stale data (the scanner observes, decisions require an assigner). Collecting an inherent attribute by convention engine produces falsely automated metadata (the value comes from entity existence alone; decisions exclude influence on inherent values).

## See also

- `REF.PROVENANCE.CLASSIFICATION` — the provenance classification pattern this illustrates
- `TERM.INHERENT.ASCRIBED` — definitions of each provenance class
- `MAX.CODE.DRY.PRINCIPLE` — single authoritative representation; each attribute has one collection path
