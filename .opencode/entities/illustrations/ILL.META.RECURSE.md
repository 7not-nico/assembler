---
id: ILL.META.RECURSE
title: "Bivalent Entity — Domain and Entity in One"
source: PROT.META.IDENTITY
summary: "Walkthrough of bivalent entity recursion: an 'arm' folder contains 'lines' as subdirectories (domains), each line contains entries (entities), each entry is itself an arm for the next stratum."
illustration: "A drawing project organizes body parts: arm (plane) contains lines (domains) like arm/muscles/, arm/tendons/. Each line contains entries (biceps.md, triceps.md). Each entry could be an arm for a deeper stratum."
illustrates: [REF.META.ENTITY.DUALITY]
tags: entity,walkthrough,duality,recursion,hierarchy,stratum
related: [REF.META.DATA.STRATUM, SPEC.ENTITY.ROUTING.TABLE]
---
## Rationale

Most entity systems assign each entity to exactly one domain — a one-directional container relationship. Bivalent Entity inverts this: every entity is simultaneously an entity (content of its parent) and a potential domain (container for its children), enabling recursive nesting without extraction.

A constructive-drawing project organizes anatomical knowledge. The bivalent entity pattern enables arbitrary-depth nesting where every entity is both a child of the parent and a parent of its children.

## Walkthrough

### Level 1: Arm as plane

The `arm/` directory is a plane — it groups related domains:

```
constructive-drawing/
  arm/                    ← plane (groups domains)
    muscles/              ← domain (contains entities)
      biceps.md           ← entity
      triceps.md          ← entity
    tendons/              ← domain
      distal-biceps.md    ← entity
```

`arm` is a plane. It contains domains (`muscles/`, `tendons/`). Each domain contains entities (`biceps.md`, `triceps.md`).

### Level 2: Domain IS entity, entity IS domain

Bivalence means each item fills two roles:

| Item | Role above (as entity) | Role below (as domain) |
|------|----------------------|----------------------|
| `arm/` | Entity of parent (root) | Domain for children (`muscles/`, `tendons/`) |
| `muscles/` | Entity of `arm/` | Domain for `biceps.md`, `triceps.md` |
| `biceps.md` | Entity of `muscles/` | Carrier of metadata for deeper nesting |

The entity ID encodes the descent:

| ID | Meaning |
|----|---------|
| `ARM.MUSCLES` | Arm → Muscles domain |
| `ARM.MUSCLES.BICEPS` | Arm → Muscles → Biceps entity |
| `ARM.TENDONS.DISTAL.BICEPS` | Arm → Tendons → Distal → Biceps |

Each dot-segmented step descends one stratum.

### Level 3: Extraction per Domain Container

When `muscles/` accumulates enough entries (20+), the density triggers extraction per PAT.META.DOMAIN.DIRECTORY. The domain becomes a sibling directory:

```
arm/
  muscles/           ← original, now leaner
  muscle-fibers/     ← extracted sibling
```

The extraction preserves the bivalent structure — `muscles/` remains both entity of `arm/` and domain for its remaining entries. The new sibling follows the same pattern.

## Key insight

Bivalent Entity eliminates the choice between "is this a domain or an entity?" — the answer is always both. The entity ID encodes the descent path. Extraction via REF.META.DOMAIN.DIRECTORY handles density without breaking the recursion.

## See also

- `REF.META.ENTITY.DUALITY` — the bivalent entity pattern this illustrates
- `REF.META.DATA.STRATUM` — four strata (plane, domain, entity, property); bivalence merges two
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix routing; bivalence extends routing to all segments
- `REF.META.DOMAIN.DIRECTORY` — sibling extraction when a domain accumulates density
- `REF.PROVENANCE.CLASSIFICATION` — domain membership as design decision; inherent property excluded
