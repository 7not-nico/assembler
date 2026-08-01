**Code Ring Topology** — every script under `.opencode/_scripts/` belongs to one of seven ordinal rings classified by I/O type. Inner rings are pure transformations; outer rings are operational I/O. Ring order governs dependency direction: verification follows ring order (innermost→outermost), execution follows reverse ring order (outermost→innermost).

## Rings

Ring 0 — PURE. Pure data transformations. No I/O, no side effects. Scripts prefixed `r0-*`.

Ring 1 — DB-READ. Reads entity metadata from the SQLite schema database. No filesystem access beyond the DB. Scripts prefixed `r1-*`.

Ring 2 — LOCAL-READ. Reads entity files from `.opencode/entities/`. Cross-file reference resolution. Scripts prefixed `r2-*`.

Ring 3 — REMOTE-READ. Aggregate analysis across entity types, bulk dumps. Reads from multiple sources. Scripts prefixed `r3-*`.

Ring 4 — LOCAL-WRITE. Writes to `.opencode/entities/` files. Transformations that produce file output. Scripts prefixed `r4-*`.

Ring 5 — REMOTE-WRITE. Writes to remote systems, network calls, external APIs. Scripts prefixed `r5-*`.

Ring 6 — DB-WRITE. Writes to the patlib database. Mutations to the persistent store. Scripts prefixed `r6-*`.

## Ring constraints

- Verification order follows ring order innermost→outermost: R0 validates before R1, R1 before R2, and so on through R6
- Execution order follows reverse ring order outermost→innermost: R6 calls R5, R5 calls R4, and so on inward. Inner rings never call outer rings
- A script at ring N imports from `_rb/` modules (always ring 0) or from files at the same or inward ring

## Code modules

`_rb/` modules are ring 0 (PURE) — lambdas only, no I/O, no side effects. Every `r*` script imports from `_rb/` modules. No `_rb/` module imports another `_rb/` module — they are independent silos composed by `r*` scripts.

## Applicability

All scripts under `.opencode/_scripts/` and written `code`. Ring annotations (`# ring: N`) in script headers align with filename prefixes.

---
id: SPEC.CODE.RING.TOPOLOGY
title: Code Ring Topology — Script Classification and Verification Order
source: assembler
summary: "Seven code rings govern script dependency and verification: R0 PURE → R6 DB-WRITE. Verification passes inward→outward. Execution passes outward→inward."
specifies: Seven ordinal code rings (R0 PURE → R6 DB-WRITE)
tags: [code, ring, topology, script, verification, purity, specification]
status: active
---
