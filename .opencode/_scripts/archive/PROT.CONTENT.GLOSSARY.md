---
id: PROT.CONTENT.GLOSSARY
title: "Glossary Entity — Subproject-Specific Terminology"
source: PROT.META.IDENTITY
related: [PROT.TERM.SCHEMA]
summary: "Glossary entries document project-specific terminology using body + backmatter format. GLOSS prefix belongs in subprojects. Each entry includes context and a concrete example drawn from project data."
protocol: "GLOSS prefix belongs in subprojects. Flat ID convention GLOSS.{TERM}. Files in {project}/glossary/{name}.md. Body: context + example. Backmatter: id, title, source, tags, reference, related. Source field disambiguates same-named entries across subprojects."
enforcement: Convention
archived: "Glossary entity format — entity type unused (no GLOSS.* files exist in codebase)"
priority: 4
tags: [glossary, entity, term, convention, subproject, documentation]
---

Subproject-specific terminology documented as body + backmatter files in a glossary directory. The GLOSS prefix belongs in subprojects. Each entry includes contextual definition and a concrete example from project data.

## Protocol

1. **Subproject scope** — glossary entries exist in subproject contexts. Root assembler concepts use root patlib term format instead.
2. **Flat ID convention** — IDs follow `GLOSS.{TERM}`. Subproject segment excluded from ID. Disambiguation via `source:` backmatter field.
3. **Directory** — glossary files at `{subproject}/glossary/{name}.md`. Subdirectories excluded.
4. **Body format** — body provides definition with context and at least one concrete example drawn from project data.
5. **Backmatter fields** — each file declares `id` (bare), `title` (quoted), `source` (subproject name), `tags` (csv), `reference` (array), `related` (array of GLOSS.* IDs).
6. **Source disambiguation** — same-named entries in different subprojects distinguished by `source:` field value.

## Gotchas

| Antipattern | Detection | Redirect |
|---|---|---|
| GLOSS entry in root assembler | glossary/ directory in root `.opencode/` | Move to subproject — use root patlib term format for cross-project concepts |
| ID includes subproject segment | `GLOSS.DARKESTDUNGEON.TIMESCRIPT` | Use flat ID: `GLOSS.TIMESCRIPT`. Source field provides disambiguation |
| Body lacks example | Entry describes term abstractly with no project-specific instance | Add a concrete example from project data |
| Entry shorter than 3 sentences | Body contains only a definition line | Expand to minimum 3 sentences: what it is, how it works in context, concrete example |
| Backmatter missing required field | File missing `id`, `title`, or `source` | Add all three required backmatter fields |

## Enforcement

Code review. New glossary entries verified against the body format, backmatter completeness, and flat ID convention.

## Applicability

Any subproject that documents domain-specific terminology with project-internal examples. Projects without glossary directories are excluded.

## See also

- PROT.TERM.SCHEMA — root patlib term format (the generality threshold for promotion)
- PROT.META.DOMAIN — protocol creation conventions
