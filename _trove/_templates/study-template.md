# {Domain} — catalog architecture document

**Layer:** task-study/
**Naming:** `catalog-architecture.md` or `{topic}.md` — how the catalog and its pipeline work.
**Composes with:** `task-backup/` (pre-edit restore point referenced), `task-fixture/fixtures.md`, `_trove/AGENTS.md`.

## Architecture

{one paragraph: the subsystem under study — acquisition scripts, meta.json, findings.db, toolchain; data flow; key design decisions}

## Diagrams / Flow

{code-block diagram or flow showing the composition — components and their connections}

```
search → download-invariants.sh → {domain}/{subdomain}/*.pdf → meta.json → register-invariants.rb → findings.db → toolchain query
```

## Change inventory — files and code lines

Authoritative diff anchor: {backup restore point}. Every edited line listed:

| File | Lines | Change |
|------|-------|--------|
| `{file}` | {lines} | {what changed and why} |

The change inventory is the authoritative list — the fixtures derive from it.

## Verification

{how the architecture proves correct — `file` sweeps, DB row counts, harness reruns}

## Instance

{date, project, outcome}
