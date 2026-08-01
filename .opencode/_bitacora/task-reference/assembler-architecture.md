---
name: assembler-architecture
description: Four-layer model defining how rules, skills, commands, and tools relate
---

**Four-layer ontology** — each layer has distinct nature, loading mechanism, and storage.

**Rules** — always loaded, universal truths.
- Stored in `.opencode/rules/*.md`, injected via `opencode.json` `instructions`
- Aphorisms and principles — no DB needed

**Skills** — auto-detected, DB-backed.
- Stored in `skills/*/SKILL.md`, synced to `skill.db`
- Query `skill.db` for triggers, procedures, scripts
- Query `patlib.db` and other DBs at runtime — do not hardcode paths
- LLM loads autonomously when trigger matches task

**Commands** — user-initiated, directed structured guidance.
- Stored in `commands/*.md`, loaded via `/command`
- Provide structured reasoning scaffold for assembler-specific workflows
- Do not inline patterns covered by skills or rules

**Tools** — called by agent, backed by `_lib/`.
- Stored in `tools/*.ts`, import from `_lib/`
- Every tool clearly read or write — never both
- No tool imports another tool

**Principles**:
- If a pattern appears in 2+ commands, promote to skill or rule
- Skills query DBs instead of hardcoding paths and procedures
- Commands are the only layer that requires user initiation
