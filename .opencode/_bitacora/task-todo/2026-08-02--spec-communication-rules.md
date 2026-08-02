# Spec Communication Rules Compliance

Status: completed (2026-08-02)

## Tasks

- [x] survey all 26 specs against rule set
- [x] rewrite SPEC.CODE.RING.TOPOLOGY — full compliance
- [x] rewrite remaining 25 specs — full compliance pass
- [x] verify no action nouns or `-ed` verbs remain in prose (rg sweeps)
- [x] sync — `r6-patlib-sync.rb --type specifications` (26, exit 0)
- [x] embed — `semantic-embed.ts --type specifications --force` (26, exit 0)
- [x] drift check — `semantic-drift.ts --type specifications --check` (0 missing, 0 stale)
- [x] write task report

## Context

- User directive (2026-08-02): use communication rules on specs, proper English, no gerunds, no action nouns, no `-ed` verbs
- Rule scope: prose body + `summary:` fields; labels (entity-type names, titles, tags, headings, frontmatter, code identifiers) retain action forms
- All 26 files at `.opencode/entities/specifications/` rewritten; entity IDs, titles, tags, schema unchanged
