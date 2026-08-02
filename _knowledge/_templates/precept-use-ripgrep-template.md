---
id: TEMPLATE.PRECEPT.USE.RIPGREP
title: Use-Ripgrep Precept Template — rg for Content Search
layer: precept/
purpose: "All content searches run through ripgrep."
naming: use-ripgrep.md
tags: [template, precept, search, tooling]
status: active
---
# use-ripgrep.md

**Layer:** precept/
**Naming:** `use-ripgrep.md` — declarative action-domain, atomic, one rule per file.
**Composes with:** invariant `record-consistency.md` (command logging).

## Rule

All content searches run through `rg` (ripgrep).

## Scope

Session-level; every command-line search across source, records, and tooling.

## Order / Practice

1. `rg -n PATTERN PATH` returns line-numbered matches.
2. `rg -l PATTERN PATH` lists files; `rg -c` counts matches.
3. Parity with grep holds ({n}/{n} on the {test} dir) at a **{speedup}×** speedup ({slow} ns vs {fast} ns over {n} iterations, `date +%s%N`).

## Example

```bash
rg -n "GBOverrideApply" {repo}/src/{domain}/overrides.c
```

## Instance

{date, project, outcome — the parity check that measured the speedup}
