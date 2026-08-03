# 20260802-125500 — Skills tables → code blocks conversion

## What was done

Converted every markdown table in `.opencode/skills/*/SKILL.md` to an aligned fenced code block. Seven of 17 live skills carried tables (175 table lines total).

| Skill | Table lines | Tables |
|-------|-------------|--------|
| knowledge-ruby | 81 | 1 (file map under Procedure step 0) |
| use-playwright-network-storage | 26 | 2 (network tools, storage tools) |
| use-playwright-core | 23 | 1 (tool reference) |
| use-playwright-debug | 14 | 1 (debug tool reference) |
| use-playwright-vision | 14 | 2 (tools, when-to-use) |
| survey-scripts | 11 | 2 (report routing, survey types) |
| use-playwright-ai-mode | 6 | 1 (technique steps) |

## Method

Wrote `/tmp/opencode/tables-to-codeblocks.py` — a Python converter that:

- Splits table cells on `|` only **outside backtick spans** (cells contain `` `|` `` set-union operator, `` `\|` `` escapes)
- Drops `---` separator rows, keeps header rows
- Aligns columns with `.ljust` padding to the widest cell per column
- Preserves the block's original indentation (list-nesting context in Procedure steps)
- Emits ``` fences with `text`-less plain blocks

## Manual fixes after conversion

Two knowledge-ruby rows corrupted by in-cell pipes that the backtick tracker missed:

- `array-set.md` — cell held unescaped `|` (`Set ops: |, &, -, union, intersection, difference`) → split into phantom columns
- `integer-bitwise.md` — cell held escaped `\|` → split at the escape

Both restored to single-line aligned rows (`&, |, ^, ~, <<, >>, [], allbits?, bit_length`).

## Verification — PASS

- Residual tables: `grep -cE '^\s*\|'` → zero across all 17 live skills
- Fence parity: every file has an even count of `^``` ` fences — all blocks open and close
- Structural checks hold: `Rules=0 SeeAlso=0 ##=0` across 17 live skills + `.template/SKILL.md`
- All 7 converted files reviewed by eye — alignment, header retention, gotchas intact

## Decisions

- Code blocks use plain fences (no language tag) — these are reference tables, not executable code
- Headers stay as the first aligned row inside the block — preserves the column-label context
- In-cell `|` operators render as plain text inside fences — no escaping needed post-conversion

## Open edges

- Gotchas positive-redirect pairing audit pending (survey-scripts retains 2 non-paired gotchas)
- DB: 66 skill rows vs 17 live dirs — 49 orphan rows + 4 live skills missing rows (manage-bash-flows, reason-invariants, structure-stdout, survey-scripts); sync lib disabled
- `skills.related` DB column stale (source field removed)
- `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — rule-level rewrite candidate
- `_disabled/audit-skills.ts` updated but server not reactivated
- survey-scripts references Ruby (`r*-*.rb`, `_rb/`) — stale-language item per bash-first direction

## Logs

- Conversion script: `/tmp/opencode/tables-to-codeblocks.py` (ephemeral — outside repo)
- No bitacora-logged command run (conversion via script, edits via Edit tool)

## Todo state

Metadata: complete. Stale archive: complete (26 archived, 17 live). Anchor rewrite: complete. Body canonical set: complete (17/17). Tables → code blocks: complete (17/17, zero residual). Remaining: gotcha pairing audit, final audit + sync, DB reconciliation, rule cleanup.
