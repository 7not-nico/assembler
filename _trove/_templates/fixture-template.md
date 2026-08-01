# {action}-{domain}-test.{ext} — atomic catalog fixture

**Layer:** task-fixture/
**Naming:** `{action}-{domain}-test.{ext}` — atomic regression harness (bash/Ruby script or sweep).
**Composes with:** `task-study/catalog-architecture.md`, `task-invariant/invariants.md`; rerun after any change in its domain.

## Header contract

Every fixture file carries a header comment block stating:

1. **Purpose** — the exact property proven (one sentence)
2. **Build/run commands** — the execute lines
3. **Proves** — the assertion set: expected output, exact counts, zero violations

## Structure

```{ext}
# {action}-{domain}-test.{ext} — atomic fixture: {one-line purpose}
# Run:   {command}
# Proves {expected property} before any {registration/integration step}.

{constants — expected counts/keys}
{main: assert each expectation, report PASS/FAIL per check, non-zero exit on any failure}
```

## Verification

{how the fixture reports — per-check PASS lines, aggregate result, exit code. What a rerun must show after a change}

## Instance

{date, project, outcome — the run that proved the component before integration}
