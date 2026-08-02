---
id: TEMPLATE.PRECEPT.RUN.FIXTURES
title: Run-Fixtures Precept Template — Fixtures After Every Source Change
layer: precept/
purpose: "After any source change, the test suite and fixture harnesses rerun before the change records."
naming: run-fixtures.md
tags: [template, precept, fixture, test]
status: active
---
# run-fixtures.md

**Layer:** precept/
**Naming:** `run-fixtures.md` — declarative action-domain, atomic, one rule per file.
**Composes with:** fixture harnesses + the {suite} suite.

## Rule

After any source change, the test suite and the fixture harnesses rerun before the change records.

## Scope

Task-level; triggers on every source edit (test, fixture, or core code).

## Order / Practice

1. The touched target builds: `cmake --build build --target {name} -j$(nproc)`.
2. The full suite runs: `ctest --test-dir build --output-on-failure`.
3. The fixtures run: `{fixture-1}.sh` ({n}/{n}), `{fixture-2}.sh` ({n}/{n}).
4. The before/after counts record in the report.

## Example

```bash
ctest --test-dir build 2>&1 | grep "tests passed"   # {n}/{n} after {fix}
```

## Instance

{date, project, outcome — the first rerun that caught a regression}
