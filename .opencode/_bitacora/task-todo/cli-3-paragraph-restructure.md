# cli-3-paragraph-restructure

Status: completed
Created: 2026-08-03

## Goal

Restructure all CLI entities to the bullet-junction format: 5 sections (Identity / Function / Usage / Design / Ecosystem), junction bullets, proper English (present-tense finite verbs, no -ed verb forms), ≤33 words per bullet.

## Tasks

- [x] Rewrite CLI.RIPGREP.md — bullet junctions, proper English
- [x] Rewrite CLI.PANDOC.md — bullet junctions, proper English
- [x] Rewrite CLI.TRACEXEC.md — bullet junctions, proper English
- [x] Rewrite CLI.COREUTILS.md — bullet junctions, proper English
- [x] Rewrite CLI.SED.md — bullet junctions, proper English
- [x] Verify: 5 sections, junction bullets, no bold, no -ed forms, no md tables

## Decisions

- Paragraph contract evolved: 3-para → 5-para → bullet-junction (5 sections, junction bullets)
- Budget: ≤33 words per bullet
- Prose ground: BULLET.template.md + DECLARATIVE.template.md
- Every bash command pipes through `bitacora-log.sh`

## Reports

- task-report to be written at completion
