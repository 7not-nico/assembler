# 20260801-180338 — Rules-tree overhaul, three new skills, stdout contract

## What was done

### 1. Rule-tree overhaul (`/home/eddyr/assembler/.opencode/rules/`)

**Communication family (12):**
- Count corrected 10 → 12 (10 principles + modifier + prose-notation bridge)
- All compose lines converted from positional ordinals (`first of 10`…) and junction positions (`1 of 12`…) to uniform membership phrasing `one of 12 communication principles`
- Negation removed from Category-1 statements (active, affirmative, declarative, finite, noun, verb)

**Code precepts (`RUL.CODE.PRECEPT`, 17 new files):**
- Created `code-{name}.md` for each precept: description-of-work prose, Scope, `Composes with RUL.CODE.PRECEPT — one of 17 code precepts`
- Negation removed from 7 files (never/no/not/rather than/instead of → affirmative)

**Compose-line standardization (all families):**
- Every rule now declares `one of {X}` with filesystem-accurate counts: writing 22, workflow 10→11, communication 12, code precept 17, code signature 4, logic 7, philosophy 5, style/language/analysis/entity 1 each
- `code-style-ruby.md` and `linguistic-lambda-penalty.md` gained missing compose lines
- `system-illustration-scope.md`: `nexi` → `nexus` (fourth-declension, singular=plural), count aligned `one of 1`
- Writing/workflow rules converted from imperative to declarative register (30 files) per `RUL.DECLARATIVE.OVER.IMPERATIVE`
- Capitalization pass: every live rule opens with an initial uppercase letter (~50 files)

**New rule:**
- `workflow-bitacora-stdout.md` — every command output pipes through the log wrapper into `_bitacora/task-stdout/` (family now 11)

**Contradiction fix 5 (batch vs parallel):**
- `workflow-batch-sequence.md`: bold title removed from body; scope clarified — the sequencing constraint bounds task-aspect transitions, leaves tool-call batching parallel

### 2. Three new skills (`/home/eddyr/assembler/.opencode/skills/`)

| Skill | Purpose | Nexus relation |
|-------|---------|----------------|
| `manage-bash-flows` | Generate atomic bash scripts + orchestrators | NEX.META.ORCHESTRATION, NEX.ACQUIRE.PIPELINE |
| `reason-invariants` | Identify + reason about invariant state facts | NEX.TOOL.SEQUENCE |
| `structure-stdout` | Structure stdout pipes for consumer value | NEX.ACQUIRE.PIPELINE, NEX.TOOL.SEQUENCE |

All: imperative register, affirmative framing (zero negations), no `patterns:` field, no markdown tables (code blocks only).

**structure-stdout contract:** keyed `KEY=value` last line → `tail -1 | cut -d= -f2`; diagnostics to stderr; ripgrep queries (`rg '^KEY='`, `rg -P -o '^KEY=\K.*'` — PCRE2 flag required); qalc-derived metrics from raw keys.

## Decisions

- Junction positional numbering (`1 of 12`) rejected — uniform `one of X` membership phrasing required
- Negation exemptions preserved (self-referential rules, formal NOT, example contrasts, `not in`, `instead of` mappings)
- Skills relate only to nexus entities; `patterns:` field removed from new skills
- Markdown tables banned in skills — code blocks carry structured output
- `rg` replaces `grep` for keyed extraction; `\K` requires `-P`
- qalc (5.12.0) computes derived metrics, citing source keys

## Errors found / fixed

- `rg -L` misread as files-without-match — it is `--follow` (symlinks); the "83 rules missing counts" alarm was a false positive (verified: all 83 live rules carry `one of N`)
- `workflow-batch-sequence` negation introduced by Fix-5 edit (`not call batching`) → `leaves call batching parallel`
- `rg -o '^KEY=\K.*'` without `-P` fails: `unrecognized escape sequence` — PCRE2 flag required, documented
- Final negation scan: 9 remaining hits, all intended Category-2/3 exemptions

## Open edges

- New skills not in runtime registry until next session start (skill tool cannot load them this session)
- Contradiction fixes 1, 3, 4 still open (lambda vs prose scope, camelCase function/method split, AGENTS.md 3-segment vs rule 4-segment PAT)
- Path drift: `run-logged.sh` lives at `_codex/_templates/shell/run-logged.sh`, AGENTS.md documents `_templates/run-logged.sh`
- qalc section in `structure-stdout` added late — full re-read of the file pending

## Todo state

- [x] Communication recount + uniform phrasing
- [x] Code precept files (17)
- [x] Negation removal (Category 1)
- [x] Capitalization pass
- [x] Declarative register conversion
- [x] Compose-line standardization
- [x] Fix 5 (batch vs parallel)
- [x] workflow-bitacora-stdout rule
- [x] Three skills created + verified
- [x] Skill stdout verification (rg, qalc, bitacora log)
- [ ] Skill registry reload (next session)
- [ ] Fixes 1, 3, 4 (open by choice)
