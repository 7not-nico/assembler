**OpenCode Custom Tools** — callable functions the LLM can invoke during conversations. Defined in `.opencode/tools/` (project-level) or `~/.config/opencode/tools/` (global) via the `tool()` helper from `@opencode-ai/plugin`. The filename determines the tool name; multiple exports per file become `<filename>_<exportname>`. Custom tools override built-in tools of the same name. Differ from OpenCode Commands (`/command`) in that tools are auto-discovered and called by the LLM directly, not triggered by user slash-commands.

---
id: TERM.OPENCODE.CUSTOM.TOOLS
title: OpenCode Custom Tools
source: CON.TOOLCLASS.AUTOMATON
tags: [opencode, tools, custom-tools, custom-ipc, convention, architecture]
related: []
reference:
  - title: OpenCode — Custom Tools
    url: https://opencode.ai/docs/custom-tools/
  - title: OpenCode — Tools
    url: https://opencode.ai/docs/tools/
  - title: OpenCode — Custom Tools Guide
    url: https://opencode.ai/docs/custom-tools/
---