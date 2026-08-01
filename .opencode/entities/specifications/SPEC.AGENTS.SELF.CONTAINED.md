**Agent Instructions Self-Containment** — an AGENTS.md file describes only its own domain and its own processes. It never mentions the existence, content, or responsibilities of a preceding agent's instructions. Cross-references to other agent instruction files create stale pointers — the preceding project changes, the reference breaks, and a broken window appears.

## Rule

- Self-description only — an AGENTS.md file states its own domain, structure, toolchain, and conventions. It names no other AGENTS.md file and describes no other agent's responsibilities.
- No existence mentions — a file never records that another agent instructions file exists, whether upstream or downstream. The reader discovers the hierarchy through the filesystem, not through references.
- No responsibility descriptions — a file never lists what a preceding agent does, provides, or governs. Each project states its own ownership alone.
- Ownership phrase — the Delegation section, when present, contains a single self-ownership statement: "This project owns {domain}." No provider, no governor, no parent is named.
- No preceding-agent rationale — decisions reference the project's own rules only. A rule that exists because "the parent governs it" belongs in the parent, not in the child.

## Applicability

All AGENTS.md files in the workspace: root, project, subproject, and dive-project instruction files.

---
id: SPEC.AGENTS.SELF.CONTAINED
title: Agent Instructions Self-Containment — No Preceding-Instruction References
source: assembler
summary: "An AGENTS.md file describes only its own domain and processes. It never mentions the existence, content, or responsibilities of a preceding agent's instructions — cross-references create stale pointers and broken windows."
specifies: Self-containment of AGENTS.md files
tags: [agents, instructions, self-containment, broken-window, specification]
status: active
---
