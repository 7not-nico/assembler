# 002 — Report Directory Structure

**Date:** 2026-07-25T21:16:01-06:00
**Status:** Accepted

## Context

Scripts produce stdout output and need to persist results. No convention existed for where to store outputs.

## Decision

Three report directories under `scripts/report/`:

| Directory | Content | Format |
|-----------|---------|--------|
| `report/conclusions/` | Script output with no violations, summary data | `.txt` |
| `report/errors/` | Script output that found violations | `.txt` |
| `report/walkthroughs/` | Agent process documentation (what was done, not raw output) | `.md` |

Plus session tracking:

| Directory | Content | Format |
|-----------|---------|--------|
| `todo/` | Per-session task lists | `.md` |

## Consequences

- Raw script stdout goes to conclusions/ or errors/ depending on result
- walkthroughs/ documents agent process, not raw data
- Timestamps use ISO 8601 (`date -Iseconds`)
- Same timestamp = overwrite. Use unique per session.
