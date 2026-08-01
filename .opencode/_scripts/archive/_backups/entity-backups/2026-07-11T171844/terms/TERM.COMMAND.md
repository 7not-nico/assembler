**Command** — a stateless slash-triggered workflow defined in `commands/*.md`. Invoked via `/command-name` at the agent prompt. Frontmatter: `description` + `subtask: true`. Body: numbered steps, no branching, no state. No DB table — lives only in markdown.

---
id: TERM.COMMAND
title: Command
source: assembler
tags: command,workflow,slash,stateless,opencode
terms: []
patterns: [PAT.SHARED.LIB]
related: []
reference:
  - title: format-command skill — command formatting guidelines
    url: https://opencode.ai/docs
  - title: OpenCode custom commands
    url: https://opencode.ai/docs
  - title: /data-flow — example command
    url: https://opencode.ai/docs
---