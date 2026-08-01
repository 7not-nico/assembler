---
id: PROT.SKILL.PROFILE
title: "Skill State Classification — Declare State Profile in Frontmatter"
source: NEX.TOOL.CHOICE
related: []
summary: "Every skill must declare its state interaction profile in frontmatter — determines testing, isolation, and dependency strategy."
protocol: "Every .opencode/skills/*/SKILL.md must include a state-profile field in frontmatter with one of five values. The profile must match the skill's actual read, write, and validate operations."
enforcement: Formality
status: active
priority: 3
tags: [skill, frontmatter, state, enforcement, convention]
---

Every skill declares its state interaction profile in frontmatter. The profile determines testing strategy, isolation guarantees, and dependency management.

## Protocol

1. **Declare `state-profile` in every `SKILL.md` frontmatter** — the profile name is one of five allowed values.
2. **Use `stateless` for skills with zero reads, writes, or validations** — DB mocking excluded. Pure decision guidance only.
3. **Use `stateful-reader` for skills that read without writing or validating** — reads from DB or filesystem. Returns results without modifying state.
4. **Use `stateful-writer` for skills that write without reading** — writes to DB or filesystem from parameters or internal logic. Input validation excluded.
5. **Use `stateful-auditor` for skills that read and validate without writing** — inspects state and reports compliance. Side effects excluded.
6. **Use `hybrid` for skills that read, write, and validate** — full state interaction. Must validate before writing.
7. **Match the declared profile to actual operations** — a skill that reads and writes without validation belongs to `stateful-writer` class. `hybrid` requires explicit validation in the skill body.

## Gotchas

- Missing `state-profile` in SKILL.md frontmatter: Add `state-profile: {one of five values}` — each skill must declare its state interaction profile (Frontmatter lacks `state-profile` field)
- Skill declared `hybrid` without validation logic: Use `stateful-writer` instead — hybrid requires explicit validation. A skill that writes without validating belongs to writer class (`state-profile: hybrid` paired with skill body lacking validation step)
- Skill declared `stateful-auditor` with write operations: Use `hybrid` instead — auditor reads and validates only. Write operations make it a hybrid (`state-profile: stateful-auditor` paired with skill body containing `db.run()` or `writeFileSync`)
- Skill declared `stateless` with DB reads: Use `stateful-reader` instead — stateless means zero reads. Any read moves it to stateful (`state-profile: stateless` paired with skill body containing `db.query(...)`)
- Invalid `state-profile` value: Use one of `stateless`, `stateful-reader`, `stateful-writer`, `stateful-auditor`, `hybrid` (Profile value outside the five allowed values)

## Enforcement

`audit-skill` checks every `SKILL.md` for the `state-profile` frontmatter field and verifies it is one of the five allowed values. `read-validate` performs semantic inference from body content — it flags mismatches between the declared profile and actual operations (DB calls, file I/O, validation steps). Run `audit-skill` after creating or editing any skill.

## Applicability

All AMANDA projects with `.opencode/skills/` directories — any file at `.opencode/skills/*/SKILL.md`.

## See also

- `TERM.SKILL.STATECLASS` — five-category taxonomy
- `PROT.TOOL.AUTOMATON` — analogous classification system for tools
- `audit-skill` — tool-enforced compliance checking
- `guide-architecture` — layer decision tree that includes state-profile declaration
- `REF.LIB.MUTATION.STRATEGY` — related state classification for DB mutation patterns
