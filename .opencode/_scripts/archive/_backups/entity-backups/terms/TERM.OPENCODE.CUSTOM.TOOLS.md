**OpenCode Custom Tools** — callable functions the LLM can invoke during conversations. Defined in `.opencode/tools/` (project-level) or `~/.config/opencode/tools/` (global) via the `tool()` helper from `@opencode-ai/plugin`. Its filename determines the tool name; multiple exports per file become `<filename>_<exportname>`. Custom tools override built-in tools of the same name. Its documentation at `opencode.ai/docs/custom-tools/` is the authoritative reference — not memory, nor external sources.


---
reference:
---
