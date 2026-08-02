**Code Ring Topology** — every script under `.opencode/_scripts/` belongs to one of seven ordinal rings by I/O type. Inner rings transform data purely; outer rings operate on I/O. Ring order governs dependency direction: scripts verify in ring order (innermost→outermost) and execute in reverse ring order (outermost→innermost).

## Rings

Ring 0 — PURE. Transforms data; no I/O, no side effects. Scripts carry the `r0-*` prefix.

Ring 1 — DB-READ. Reads entity metadata from the SQLite schema database. No filesystem access beyond the DB. Scripts carry the `r1-*` prefix.

Ring 2 — LOCAL-READ. Reads entity files from `.opencode/entities/`. Resolves cross-file references. Scripts carry the `r2-*` prefix.

Ring 3 — REMOTE-READ. Analyzes across entity types; dumps in bulk. Reads from multiple sources. Scripts carry the `r3-*` prefix.

Ring 4 — LOCAL-WRITE. Writes output files to `.opencode/entities/`. Scripts carry the `r4-*` prefix.

Ring 5 — REMOTE-WRITE. Writes to remote systems, network calls, external APIs. Scripts carry the `r5-*` prefix.

Ring 6 — DB-WRITE. Writes to the patlib database. Mutates the persistent store. Scripts carry the `r6-*` prefix.

## Ring constraints

- Scripts verify in ring order innermost→outermost: R0 validates before R1, R1 before R2, and so on through R6
- Scripts execute in reverse ring order outermost→innermost: R6 calls R5, R5 calls R4, and so on inward. Inner rings never call outer rings
- A script at ring N imports from `_rb/` modules (always ring 0) or from files at the same or inward ring

## Code modules

`_rb/` modules are ring 0 (PURE) — lambdas only, no I/O, no side effects. Every `r*` script imports from `_rb/` modules. No `_rb/` module imports another `_rb/` module — they are independent silos; `r*` scripts compose them.

## Applicability

All scripts under `.opencode/_scripts/` and all code files. Ring annotations (`# ring: N`) in script headers align with filename prefixes.

---
id: SPEC.CODE.RING.TOPOLOGY
title: Code Ring Topology — Script Rings and Verification Order
source: assembler
summary: "Seven code rings govern script dependency and verification: R0 PURE → R6 DB-WRITE. Scripts verify inward→outward. Scripts execute outward→inward."
specifies: Seven ordinal code rings (R0 PURE → R6 DB-WRITE)
tags: [code, ring, topology, script, verification, purity, specification]
status: active
---
