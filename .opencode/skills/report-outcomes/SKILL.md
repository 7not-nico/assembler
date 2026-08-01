---
name: report-outcomes
description: Use this skill when completing a task — it writes timestamped outputs to scripts/report/, scripts/docs/, scripts/dataflow/, and related directories. Each script/module is atomic per MAX.ATOMIC.CONCERN.
state-profile: stateless
related: ["RUL.REPORT.WRITE", "RUL.TODO.TRACK"]
patterns: ["MAX.ATOMIC.CONCERN", "MAX.DRY", "MAX.ORTHOGONALITY"]
terms: ["IDENTITY.MAXIM"]
---
**Procedure**

0. **On task completion** — before concluding, write outputs to `scripts/report/`, `scripts/docs/`, `scripts/dataflow/`, `scripts/guides/`, `scripts/decision/`, `scripts/equivalence/`, `scripts/spec/`, `scripts/template/`, and `scripts/todo/`:

   | Output type | Directory | Format |
   |-------------|-----------|--------|
   | No errors, summary data | `report/conclusions/` | `{script}-{timestamp}.txt` |
   | Errors or violations | `report/errors/` | `{script}-{timestamp}.txt` |
   | Multi-step traces | `report/walkthroughs/` | `{script}-{timestamp}.md` |
   | Uncovered documentation | `docs/` | `{ref,flow}-{topic}.md` |
   | Data flow documentation | `dataflow/` | `{ref,flow}-{topic}.md` |
   | Implementation guides | `guides/` | `{topic}.md` |
   | Architectural decisions | `decisions/` | `{NNN}-{topic}.md` |
   | Code ↔ math mappings | `equivalence/` | `{topic}.md` |

1. **Write todo** — create or update `scripts/todo/{session-timestamp}.md` with:

   - Task list (pending, in-progress, completed, cancelled)
   - One concern per script per MAX.ATOMIC.CONCERN
   - Timestamp on each entry

2. **Atomic separation** — each `_rb/` file and each `r*-*.rb` script isolates exactly one concern:

   - `_rb/` — functional core, pure lambdas, no I/O
   - `r*-*.rb` — imperative shell, owns I/O, calls core
   - One change reason per file. Two independent causes → split

3. **Cross-check** — before writing reports:

   - Verify every `r*-*.rb` script ran without errors
   - Verify outputs match expected format (Table, List)
   - Verify timestamps are ISO 8601

**Ring naming** — `r{ring}` in filename must match MAX.CODE.LAYERS verification model: r1=PURE (foundational), r2=DB-READ (entity metadata), r3=LOCAL-READ (cross-file refs), r4=REMOTE-READ, r5=LOCAL-WRITE, r6=REMOTE-WRITE, r7=DB-WRITE. Audit against `r*-*.rb` filenames periodically.

**Gotchas**

- `scripts/todo/` uses `.md` files; `scripts/report/` uses `.txt` files
- `scripts/docs/` and `scripts/dataflow/` use `.md` files with `{ref,flow}-` prefix per ludoteca convention
- `scripts/guides/` uses `.md` files with plain `{topic}.md` naming
- `scripts/decision/` uses `.md` files with `{NNN}-{topic}.md` naming, sequential per session
- Timestamp format: `date -Iseconds` or `YYYY-MM-DDTHH:MM:SS±HH:MM`
- Reports overwrite on same timestamp — use unique per session
- `_rb/` files stay pure — no puts, no File.read
- `archive/` holds deprecated scripts; `spec/` holds tests; `template/` holds boilerplate; `equivalence/` holds code↔math mappings
- Scripts follow `MAX.RUBY.ONLY` — Ruby 3.x stdlib, no gems, no other runtimes

**Rules**

- Every task session produces at least one report file
- Every task session maintains a todo file
- Each file has exactly one concern — if a second concern emerges, split into a separate file
- Shell scripts import from `_rb/` via `require_relative`; `_rb/` never imports from shell
