---
id: TEMPLATE.BACKUP
title: Backup Template — Restore Point Convention
layer: backup/
purpose: "Restore-point convention: source tree anchor + timestamped binaries; the diff base."
naming: repo-src/ + repo-binary-YYYYMMDD-HHMMSS
tags: [template, backup, restore]
status: active
---
# Backup convention — restore points

**Layer:** backup/
**Purpose:** restore points taken before any source study or edit; the diff anchor for the change inventory.
**Naming:** `{repo}-src/` (source tree, no artifacts) + `{repo}-binary-{YYYYMMDD}-{HHMMSS}` (timestamped binaries).
**Composes with:** `study/{domain}-architecture.md` (change inventory references the anchor), `procedure/extend-*.md` (backup precedes source edits).

## Convention

1. Backup precedes any source study or edit — a restore point exists before the first change.
2. `{repo}-src/` holds the pre-edit source tree (no build artifacts). It is the authoritative diff anchor for the change inventory.
3. Timestamped binaries capture pre-edit build state — `{repo}-binary-{YYYYMMDD}-{HHMMSS}`.
4. Every change inventory lists its diff anchor: `backup/{repo}-src/{file}` vs `{repo}/{file}`.
5. A new backup is taken when a new study/edit phase begins; the inventory points at the phase's anchor.

## Verification

A diff against the anchor reproduces the change inventory exactly — every edited line listed in `study/` appears in the diff, no more.

## Instance

{date, project, outcome — the phase whose backup anchored the change inventory}
