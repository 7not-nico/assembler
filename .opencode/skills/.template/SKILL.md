---
# Skill template — canonical format for .opencode/skills/{name}/SKILL.md
# Rules governing this file: PROT.SKILL.SCHEMA (Rule 9 frontmatter), PROT.SKILL.PROFILE (state-profile),
# refactor-skill (body sections), RUL.COMMUNICATION.* (imperative/affirmative prose).
# Copy this file to .opencode/skills/{action}-{domain}/SKILL.md and fill each field.
# Delete this comment block after filling.

name: {action}-{domain}
description: Use this skill when {trigger condition} — {one sentence on what it covers}
state-profile: {stateless|stateful-reader|stateful-writer|stateful-auditor|hybrid}
nexus: NEX.{DOMAIN}.{ASPECT}
---

**Trigger**

{1-3 sentences stating the load condition. The description doubles as the trigger per PROT.SKILL.SCHEMA Rule 7; this section states the operational condition in prose.}

**Procedure**

{Numbered steps, imperative register, affirmative framing — state what TO do. Each step names one action and its target.}

1. {Action} — {object/target} — {outcome}
2. {Action} — {object/target} — {outcome}
3. {Action} — {object/target} — {outcome}

**Gotchas**

{Each entry pairs an antipattern with a positive redirect — what TO do instead. 3+ entries.}

- {Antipattern} — {positive redirect}
- {Antipattern} — {positive redirect}
- {Antipattern} — {positive redirect}
