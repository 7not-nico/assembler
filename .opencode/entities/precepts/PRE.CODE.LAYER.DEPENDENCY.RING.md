---
id: PRE.CODE.LAYER.DEPENDENCY.RING
title: Code Layer — Dependency Ring Topology
source: assembler
summary: Seven ordinal dependency rings by I/O type. A lib file imports only from files at the same or inward ring. Verification passes inward→outward. Execution passes outward→inward.
precept: A lib file imports only from files at the same or inward ring. Inward imports are the only permitted direction.
enforcement: Tool
tags: [architecture, purity, verification, layers, import]
status: active
priority: 1
---

**Code Layer** — dependency ring topology. Seven ordinal rings. A lib file imports only inward.

## Corollaries

- Seven ordinal rings: PURE (R0) → DB-READ (R1) → LOCAL-READ (R2) → REMOTE-READ (R3) → LOCAL-WRITE (R4) → REMOTE-WRITE (R5) → DB-WRITE (R6)
- Verification runs innermost→outermost. Execution runs outermost→innermost
- Every lib file declares its ring via `// purity: {RING}` at line one
- Pure files import only from other pure files. I/O files may import from pure files
- Applies to lib files only. Tools are exempt

## Applicability

All lib files across all projects — `.opencode/_lib/`, `findings/.opencode/lib/`, `homophones/.opencode/lib/`, and any subproject lib directory.
