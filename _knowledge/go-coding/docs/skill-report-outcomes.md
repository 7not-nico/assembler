# report-outcomes — Output Management

**Purpose** — every task completion produces structured reports.

## Output Directories

```text
Content type          Directory                Format
No errors, summary    report/conclusions/      {script}-{timestamp}.txt
Errors, violations    report/errors/           {script}-{timestamp}.txt
Multi-step traces     report/walkthroughs/     {script}-{timestamp}.md
Documentation         docs/                    {ref,flow}-{topic}.md
Data flow             dataflow/                {ref,flow}-{topic}.md
Implementation        guides/                  {topic}.md
Architecture          decisions/               {NNN}-{topic}.md
Code↔math mappings    equivalence/             {topic}.md
```

## Procedure

1. **Write todo** — `scripts/todo/{session-timestamp}.md` with states: pending, in-progress, completed, cancelled. One concern per script per MAX.ATOMIC.CONCERN.
2. **Atomic separation** — `_rb/` files hold pure functional core (no I/O). `r*-*.rb` files hold imperative shell (owns I/O). One change reason per file.
3. **Cross-check** — verify runs, output format, ISO 8601 timestamps.

## Constraints

- Every task session produces ≥1 report file
- Every task session maintains a todo file
- Each file has exactly one concern — split when second emerges
- `_rb/` never imports from shell; shell imports from `_rb/` via `require_relative`
