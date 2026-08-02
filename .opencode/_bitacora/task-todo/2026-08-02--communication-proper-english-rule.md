# Communication Proper-English Rule

Topic: communication-proper-english
Status: completed (2026-08-02)

## Tasks

- [x] create `rules/communication-proper-english.md` — instruction body (no examples)
- [x] create `rules/yamls/communication-proper-english.yaml` — metadata
- [x] update 12 `communication-*.md` files: "one of 12" → "one of 13"
- [x] sync: `ruby .opencode/_scripts/r6-patlib-sync.rb --type rules`
- [x] embed: `bun run .opencode/tools/semantic-embed.ts --type rules`
- [x] drift check: `bun run .opencode/tools/semantic-drift.ts --check`
- [x] write task report referencing log files

## Context

- Request (user, 2026-08-02): new communication rule — action nouns prohibited, -ed verbs prohibited, use proper English
- Draft approved with no examples; count update 12 → 13 approved
- ID: `RUL.COMMUNICATION.PROPER.ENGLISH` (child of `RUL.COMMUNICATION.SYSTEM`)
- House style per PROT.RULE.SCHEMA + IDENTITY.RULE: YAML metadata only, no source/precedes, tags min 3
