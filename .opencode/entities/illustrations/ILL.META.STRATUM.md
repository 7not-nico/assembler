---
id: ILL.META.STRATUM
title: "Stratum Map — Entity Through Four Layers"
source: PROT.META.IDENTITY
summary: "Walkthrough of mapping a real entity through the four strata — plane, domain, entity, property."
illustration: "A category-theory chapter maps through all four strata: form-planes/ contains muscles/ which contains math-derivative.md with YAML frontmatter."
illustrates: [REF.META.DATA.STRATUM]
tags: meta,stratum,walkthrough,mapping,entity,plane,domain
related: [REF.META.ENTITY.DUALITY, REF.META.PROJECT.TOPOLOGY]
---
## Rationale

A category-theory project stores mathematical concepts. The data model uses four strata. Understanding how a specific entity maps through all four layers demonstrates the model for new projects.

## Walkthrough

1. **Plane stratum** — the top-level grouping. The directory `form-planes/` is a plane. It groups related domains under a common abstraction level. Multiple domains within the same plane share schema shape and validation rules.

2. **Domain stratum** — a directory within the plane. `form-planes/muscles/` is a domain. It contains entities related to muscle diagrams and properties.

3. **Entity stratum** — a `.md` file within the domain. `form-planes/muscles/math-derivative.md` is an entity. It has a YAML frontmatter block identifying its metadata.

4. **Property stratum** — YAML fields within the entity file. Fields like `id:`, `title:`, `domain:`, and `sources:` are properties. They describe attributes of the entity.

```
Plane:     form-planes/          (directory of directories)
  Domain:   muscles/             (directory)
    Entity: math-derivative.md   (.md file with YAML)
      Property: id: CHAP.DERIV   (YAML frontmatter field)
      Property: title: "Derivative"
      Property: domain: muscles
```

5. Each stratum addresses the one below. The plane contains domains. The domain contains entities. The entity carries properties expressed as YAML. A tool reading `math-derivative.md` traverses the strata to locate and parse the file.

6. Move in the other direction: a property change (editing `title:`) affects the entity. An entity rename affects the domain directory. A domain move affects the plane. The strata are the filesystem itself.

## Key insight

The four strata ARE the filesystem — no separate configuration maps data to storage. A directory IS a domain. A `.md` file IS an entity. YAML IS property storage. The same structure works for any project with any number of planes or domains.

## See also

- `REF.META.DATA.STRATUM` — four-strata data model
- `REF.META.ENTITY.DUALITY` — bivalent entity extension
- `REF.META.PROJECT.TOPOLOGY` — assembler architecture
