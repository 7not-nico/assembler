**Directory Ring Topology** — every folder in the assembler belongs to one of four ordinal rings by position and underscore prefix. Ring 0 is the assembler root. Ring 1 holds domain folders that carry an underscore prefix directly in the root. Ring 2 holds folders that carry an underscore prefix inside a domain. Ring 3 holds plain folders inside a domain. The underscore prefix carries the ring signal.

## R0

- Assembler root — the top-level directory
- Infrastructure as code — `.opencode/` with tooling, rules, and scripts, plus `.opencode/entities/` as the entity store
- Shared `node_modules/` — serves all subprojects; root-level resolution shadows child folders when versions diverge
- Shared `.playwright-mcp/` — serves all rings; browser automation state, downloads, and snapshots from every ring land here
- Root files — `AGENTS.md`, `opencode.json`, `.gitignore`

## R1

- Domain folders — folders that carry an underscore prefix directly in the root: `_codex/`, `_knowledge/`, `_depot/`, `_trove/`, `_atelier/`
- The underscore prefix marks a domain

## R2

- Domain infrastructure — folders that carry an underscore prefix inside a domain: `_codex/_templates/`, `_codex/_bitacora/`, `_knowledge/_templates/`
- The underscore prefix marks infrastructure and records
- Ring-2 record folders follow the `{?}-{concrete noun}` naming convention — `task-audit/`, `task-plan/`, `task-reference/`, `task-report/`, `task-survey/`, `task-todo/`. Every subfolder pairs a class prefix with a concrete noun; a bare noun or a bare prefix is invalid.

## R3

- Domain projects — plain folders inside a domain: `_codex/snes9x-repo/`, `_knowledge/rust-coding/`, `_atelier/one-timers/`
- A plain name marks a project or content folder

## Ring constraints

- The underscore prefix signals the ring: R1 and R2 use underscores; R3 uses plain names. A folder never mixes the signals.
- Scripts at the assembler root live inside `.opencode/_scripts/` — a root-level `scripts/` folder is invalid placement. The code ring system classifies every script inside it.
- Ring order governs governance: R0 root instructions govern; R1 domains follow; R2 infrastructure serves the domain; R3 projects sit at the leaves.
- A ring-3 project may carry its own AGENTS.md; the project instructions describe the project alone, per SPEC.AGENTS.SELF.CONTAINED.
- The code ring system governs what lives inside `.opencode/_scripts/`; this ring system governs where folders sit.

## Applicability

All directory placement in the assembler: domain creation, infrastructure folders, and project folders.

---
id: RING.DIRECTORY.TOPOLOGY
title: Directory Ring Topology — R0 Root, R1 Domains, R2 Infrastructure, R3 Projects
source: assembler
summary: "Four ordinal directory rings govern folder placement: R0 assembler root, R1 domains that carry an underscore prefix in the root, R2 infrastructure that carries an underscore prefix inside domains, R3 plain project folders inside domains. The underscore prefix carries the ring signal."
specifies: Four ordinal directory rings for folder placement
tags: [directory, ring, topology, folder, placement, domain, specification]
status: active
---
