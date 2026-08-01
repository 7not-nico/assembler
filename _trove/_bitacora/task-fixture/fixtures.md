# fixtures.md — atomic verification harnesses

**Layer:** task-fixture/
**Naming:** `{topic}.md` — the regression fixtures that prove pipeline components.
**Composes with:** `_trove/AGENTS.md` precedence chain; `task-invariant/invariants.md` predicates.

## Harnesses

```
F1  download-invariants.sh — curl acquisition, %PDF magic check per file,
    exit 1 on any failure (proves I2 before registration)
F2  register-invariants.rb — upsert from meta.json; bind parameters; proves
    id keying + Ruby-only writes (proves I3, I4)
F3  file sweep — `file {domain}/{subdomain}/*.pdf` audit; %PDF + page count
    (proves I1, I2)
F4  meta.json shape — 8 entries keyed by arxiv_id with filename/title/authors/
    published/category (proves I7)
F5  findings.db query — SELECT by subdomain; title/arxiv_id/published_at/
    file_size populated (proves I3)
```

## Rerun rule

Any change to `_scripts/`, the schema, or the catalog reruns the affected
harnesses. F1 precedes registration; F3 + F5 close a session.

## Fixture data

```
math/invariant-theory/meta.json   — 8-entry metadata capture (2026-07-31)
math/invariant-theory/*.pdf       — 8 validated PDFs, 4–43 pages
```
