# Communication Proper-English Rule

Timestamp: 2026-08-02 090240

## What was done

**1. New rule created.** `RUL.COMMUNICATION.PROPER.ENGLISH` — 13th child of `RUL.COMMUNICATION.SYSTEM`. Two files written:
- `.opencode/rules/communication-proper-english.md` — instruction body (3 lines, no examples per user direction)
- `.opencode/rules/yamls/communication-proper-english.yaml` — metadata: `id`, `title: Communication-proper-english`, `group: RUL.COMMUNICATION.SYSTEM`, `tags: [convention, communication, grammar, tense, verb, noun, prose]` (7 tags, inline array)

Body text: "Sentences use proper English with present-tense finite verbs; action nouns and -ed verb forms are prohibited in prose." Scope: sentence-level, prose mode only, titles/labels/quoted speech exempt.

**2. Family count updated 12 → 13.** All 12 existing `communication-*.md` files edited: "one of 12 communication principles" → "one of 13" (active, actor, affirmative, concise, declarative, finite, function, modifier, noun, prose-notation, sov, verb).

**3. patlib sync green.** `r6-patlib-sync.rb --type rules` → "Synced 79 rules" (was 78; new rule registered, body loaded from paired `.md`).

**4. Vector store green.** `semantic-embed.ts --type rules` → "embedded 1 rules". `semantic-drift.ts --check` → TOTAL: 0 missing, 0 stale across 28 tables, "no drift". Rules table: DB 79, VEC 79.

**5. Verification.** SQLite query confirms `RUL.COMMUNICATION.PROPER.ENGLISH | Communication-proper-english | convention,communication,grammar,tense,verb,noun,prose` with body prefix present.

## Decisions

- Rule ID `RUL.COMMUNICATION.PROPER.ENGLISH` — 4-segment, consistent with `RUL.COMMUNICATION.PROSE.NOTATION` precedent
- No examples in body — user direction "no examples"
- Prohibitions expressed declaratively ("prohibited") per `RUL.DECLARATIVE.OVER.IMPERATIVE`; affirmative lead ("Sentences use proper English") per `RUL.AFFIRMATIVE` / `RUL.POSITIVE.FRAMING`
- Carve-out mirrors family convention: titles, labels, quoted speech retain original forms (same exemption as noun/verb rules)
- Count consistency maintained across the whole family — no stale "12" references remain

## Open edges

- The static system-prompt listing of communication principles regenerates on next load; file count now 13
- `communication-proper-english.md` carries no `related:` and no YAML `source`/`precedes` fields — compliant with `PROT.RULE.SCHEMA` (child rule, related optional)

## Todo state

- `task-todo/2026-08-02--communication-proper-english-rule.md` — completed (all 7 tasks checked)

## Logs

- `task-stdout/20260802-090134-sync-proper-english-rule.log` — sync, 79 rules, exit 0
- `task-stdout/20260802-090135-embed-proper-english-rule.log` — embed, 1 rule, exit 0
- `task-stdout/20260802-090136-drift-check-proper-english-rule.log` — drift, 0 missing/0 stale, exit 0
- `task-stdout/20260802-090221-verify-proper-english-rule.log` — DB row verification, exit 0
