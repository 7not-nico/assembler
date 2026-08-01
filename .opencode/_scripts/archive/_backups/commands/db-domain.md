---
description: Define purpose, audience, goal, and scope of a new DB workflow project
---

Domain for `$ARGUMENTS`

Reference — existing project purposes:
- patlib: pattern and term index for all AMANDA systems
- ludoteca: video game catalog, emulator specs, hardware architecture reference
- nerdfont: glyph and icon set reference for terminal rendering
- learn-git: (what we are defining)

1.  Identify the domain — what real-world subject does this database capture? One line.
2.  Define the audience — who will query this DB? Self, team, public?
3.  State the goal — reference, learning, tracking, research, or mix?
4.  Define scope boundaries — what is explicitly excluded?
5.  Output manifest.

Write output to `{project}/.opencode/manifests/domain.md`:

```yaml
project: $PROJECT_NAME
domain: $DOMAIN_DESCRIPTION
audience: $AUDIENCE
goal: $GOAL
out-of-scope:
  - $EXCLUSION
  - $EXCLUSION
```
