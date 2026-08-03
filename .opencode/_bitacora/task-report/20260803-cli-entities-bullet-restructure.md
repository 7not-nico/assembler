# 20260803-cli-entities-bullet-restructure

Date: 2026-08-03
Status: completed

## What was done

- Deleted all five CLI entities (RIPGREP, PANDOC, TRACEXEC, COREUTILS, SED) from `.opencode/entities/cli/`
- Grounded facts for all five via MCP parallel search (creator, origin year, language, features, license, ecosystem)
- Rewrote all five entities in the bullet-junction format: 5 sections each (Identity / Function / Usage / Design / Ecosystem), junction bullets, no bold in bullets, no md tables
- Wrote in proper English: present-tense finite verbs, no `-ed` verb forms in action prose
- Updated `.opencode/_templates/CLI.template.md` to the 5-section bullet-junction contract
- Created `.opencode/_templates/BULLET.template.md` — the bullet junction writing method
- Converted all md tables to code blocks across DECLARATIVE/IMPERATIVE/BULLET templates

## Decisions

- Entity format: 5-section bullet junctions (What → Does → Use → Works → Sits), each bullet ≤33 words, one fact per bullet
- Prose ground: `BULLET.template.md` + `DECLARATIVE.template.md` govern entity bodies
- Proper English per `RUL.COMMUNICATION.PROPER.ENGLISH`: present-tense finite verbs, `-ed` forms excluded from action prose
- `_templates/` remains the sole template ground (deleted `.template.md` in cli/ and skills/)

## Verification

- 5 sections per entity (grep `^## ` = 5 each)
- 12–13 junction bullets per entity
- No bold in bullets (`grep "^- .*\*\*"` = none)
- No md tables (`grep "^|"` = none)
- Max bullet length: 20–33 words (SED max 33, within budget)
- `-ed` scan: only adjectives (oriented, embedded, expected, named, piped), labels (related), or tool names (sed/qed) — no past-tense verb forms
- All commands piped through `bitacora-log.sh` (logs in `task-stdout/`)

## Open edges

- `cli` patlib table still missing — registration deferred
- Templates not yet embedded in vector store
- Entities carry `related: []` — links to other patlib entities pending
