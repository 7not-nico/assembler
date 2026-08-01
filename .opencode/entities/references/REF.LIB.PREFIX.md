---
id: REF.LIB.PREFIX
title: "Domain-Prefixed Filename Convention — Domain in Filename"
source: PROT.LIB.CONTRACT
related: [PROT.META.DOMAIN, PROT.LIB.CONTRACT]
summary: "Every lib and plugin filename includes its domain as a prefix segment. Domain is drawn from the canonical set extended by per-project operational domains. Cross-cutting utilities use the meta domain."
ref: "Library module filenames include a domain prefix. Plugin filenames include a domain segment between the project prefix and the action. Domain is drawn from the canonical set extended by per-project operational domains. Cross-cutting utilities use the meta domain. Every module carries a domain prefix."
tags: [lib, naming, convention, architecture, domain]
---

Every library and plugin filename includes its domain as a prefix segment.

## Protocol

1. **Library domain prefix** — `lib/` module filenames use the domain as the first prefix segment: `{domain}-{name}.ts`. Action or object follows the domain.
2. **Plugin domain infix** — `plugins/` filenames use the domain between the project prefix and the action: `{project}-{domain}-{action}.ts`.
3. **Domain source** — domain is drawn from the canonical set defined in `PROT.META.DOMAIN`, extended by the project's operational domains declared in its `AGENTS.md`.
4. **Meta domain for utilities** — cross-cutting utility modules use `meta` as their domain: `meta-{name}.ts`. The meta domain signals the module serves all domains.
5. **Domain-first ordering** — domain is the first meaningful segment. Subject-verb-object ordering: required.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Plugin uses domain as suffix | Filename pattern matches {project}-{action}-{domain} | Place domain between project prefix and action |
| Utility module assigned operational domain | Module named entity-cli while serving all tables | Use meta-cli — meta signals cross-cutting scope |
| Utility module left unprefixed | Filename cli.ts with zero domain segments | Add meta- prefix — every module carries a domain |
| Operational domain undocumented | Domain appears in filename, absent from AGENTS.md | Add a Domains section to AGENTS.md listing operational domains |

## Enforcement

Code review. New `lib/` or `plugins/` files are checked for domain prefix presence and domain source validity against `PROT.META.DOMAIN` and the project's `AGENTS.md`.

## Applicability

All `lib/` and `plugins/` directories across AMANDA subprojects.

## See also

- `PROT.META.DOMAIN` — canonical domain set
- `PROT.LIB.CONTRACT` — lib module conventions
- `PROT.LIB.PURITY.BOUNDARY` — purity declarations in lib modules
