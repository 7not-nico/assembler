---
description: Convert a Hybrid or Shebang CLI tool to Custom IPC Tool pattern
subtask: true
---

Convert `$ARGUMENTS` to Custom IPC Tool

See `PROT.TOOL.DEFINITION` and `TERM.OPENCODE.CUSTOM.TOOLS` for authoritative pattern definition.

1. **Identify** — check the tool entry point: `#!/usr/bin/env bun` + `process.argv[1]` self-check = Hybrid/Shebang CLI. `export default tool({...})` = already Custom IPC Tool.
2. **Read** — the tool file and `PROT.TOOL.DEFINITION` Migration section for old→new mapping
3. **Replace** — shebang → remove. `export default function name()` → `export default tool({...})`. `console.log(x)` → `return x`. `process.argv` parsing → typed `tool.schema` args. CLI self-check → remove.
4. **Add** `import { tool } from "@opencode-ai/plugin"` at top
5. **Verify** — `bun build --target=bun .opencode/tools/<name>.ts`
6. **Update AGENTS.md** — move from CLI commands section to custom tools table

**Key mappings**

| Old | New |
|-----|-----|
| `#!/usr/bin/env bun` | remove |
| `export default function name()` | `export default tool({...})` |
| `console.log(x)` | `return x` |
| `console.error(x)` | `return "Error: " + x` |
| `process.exit(1)` | return error message |
| `process.argv[2]` | typed args via `tool.schema` |
| `if (process.argv[1]?.endsWith(...))` | remove |
