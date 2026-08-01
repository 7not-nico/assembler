---
id: PAT.SKILL.STATECLASS
title: "Skill State Classification — Declare State Profile"
source: assembler
summary: Every skill must declare its state interaction profile in frontmatter — determines testing, isolation, and dependency strategy.
principle: Every .opencode/skills/*/SKILL.md must include a state-profile field in frontmatter with one of five values — and that profile must match the skill's actual read/write/validate operations.
enforcement: Convention
status: active
priority: 3
tags: skill,frontmatter,state,enforcement,convention
patterns: [PAT.MUTATION.PATTERN]
terms: [TERM.SKILL.STATECLASS]
---

Every `.opencode/skills/*/SKILL.md` must declare its state interaction profile in frontmatter. The profile determines testing strategy (does it need DB mocking?), isolation guarantees (does it write?), and dependency management (which state must exist before it runs?).

## Context

Skills interact with persistent state differently. A stateless skill needs no DB mocking. A hybrid skill must validate before writing. A stateful-writer assumes its input is correct. Knowing the profile at a glance avoids incorrect assumptions about a skill's side effects.

Five profiles exist — see `TERM.SKILL.STATECLASS` for full definitions:

| Profile | Reads | Writes | Validates |
|---|---|---|---|
| `stateless` | No | No | No |
| `stateful-reader` | Yes | No | No |
| `stateful-writer` | No | Yes | No |
| `stateful-auditor` | Yes | No | Yes |
| `hybrid` | Yes | Yes | Yes |

## Rules

- Every `SKILL.md` must have `state-profile` in frontmatter
- Allowed values: `stateless`, `stateful-reader`, `stateful-writer`, `stateful-auditor`, `hybrid`
- `audit-skill` must check `state-profile` exists and is one of the five values
- New skills must declare profile at creation — `guide-architecture` layer decision must include this step
- A skill that reads and writes but does not validate is `stateful-writer`, not `hybrid` — validation must be explicit
- A skill that reads and validates but never writes is `stateful-auditor`, not `hybrid`
- Declared `state-profile` must match the skill's actual operations — `read-validate` enforces semantic inference from body content (DB calls, file I/O, validation steps)

## Applicability

All AMANDA projects with `.opencode/skills/` directories — any file at `.opencode/skills/*/SKILL.md`.

## See also

- `TERM.SKILL.STATECLASS` — five-category taxonomy with definitions and examples
- `audit-skill` — tool-enforced compliance checking
- `guide-architecture` — layer decision tree that includes state-profile declaration
- `PAT.MUTATION.PATTERN` — related state classification for DB mutation patterns


