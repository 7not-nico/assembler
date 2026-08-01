---
name: format-command
description: Format .opencode/commands/ files as structured steps with no fluff, emojis, or voice guidelines
state-profile: stateless
related: [PROT.COMMAND.VERB.DOMAIN, TERM.OPENCODE.COMMANDS, SKL.PROPOSE.COMMAND, SKL.AUDIT.COMMAND]
---
**Trigger** — any edit or creation of files under `.opencode/commands/`

**Procedure**

When creating or editing a command:

1. Write frontmatter — `description:` and `subtask: true`, one sentence present tense
2. Write action entry — first line reads `{Verb} for \`$ARGUMENTS\``
3. Write numbered steps — 1. 2. 3. for workflow
4. Add report table only if validation is part of the workflow
5. Add code block only if a file template is needed

**Gotchas**

- Never write voice or tone instructions — the agent already knows the voice from rules
- Never use `##` headers — use `**bold**` section headers only
- Never use em-dash elaboration — keep to single directive lines
- Never add ownership statements — the agent doesn't own the output
- Never use emoji markers — the agent doesn't need visual cues

**Rules**

- Frontmatter is `description:` and `subtask: true` — no `agent:`, `model:`, or other fields unless explicitly requested
- Body is numbered steps — no prose paragraphs
- Report tables use PASS/WARN/FAIL/SKIP — no emojis
- Code blocks are backtick-fenced — not indented
