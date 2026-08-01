# 005 — Functional Programming Pattern

**Date:** 2026-07-25T21:16:08-06:00
**Status:** Accepted

## Context

scripts/ uses Ruby as runtime. Need a consistent programming pattern that separates pure logic from I/O, is testable, and follows the project's existing conventions.

## Decision

Use **functional core / imperative shell** with these constraints:

| Core (`_rb/`) | Shell (`r*.rb`) |
|---------------|-----------------|
| Pure lambdas only | Owns all I/O |
| No classes, no `def` | Requires `_rb/` modules |
| No `puts`, `File.read`, `Dir` | Reads files, writes stdout |
| Exports as constants | One concern per script |
| Declares `# ring: 1 (PURE)` | Declares `# ring: N (NAME)` |

Lambda syntax: `Name = ->(args) { body }`. Composition via `.call` chains.

## Consequences

- No classes, instances, instance variables, or `||=` memoization anywhere
- Data transformation via `Enumerable` chains (`map`, `filter_map`, `group_by`, `flat_map`)
- Each `_rb/` file carries `# exports:`, `# ring:`, `# depends-on:` contract headers
- Guide written at `guides/functional-programming.md`
