---
name: audit-tool
description: Use this skill when auditing .opencode/tools/ files — checks every tool file against PROT.TOOL.DEFINITION, PROT.TOOL.AUTOMATON, and MAX.ORTHOGONALITY. No IDENTITY.TOOL exists — references PROT.TOOL.* protocols instead
state-profile: stateful-auditor
related: [PROT.TOOL.DEFINITION, PROT.TOOL.AUTOMATON, PROT.TOOL.COMPOSITE, MAX.ORTHOGONALITY]
patterns: ["NEX.TOOL.SEQUENCE", "MAX.ORTHOGONALITY", "PROT.TOOL.DEFINITION"]
---

**Procedure**

When auditing tools:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load protocols** — read `PROT.TOOL.DEFINITION` and `PROT.TOOL.AUTOMATON` via `read-projection`. Define custom IPC tool pattern (RECG, TRNS, GENR, SGNL), read/write separation, and import conventions. No IDENTITY.TOOL exists — identity definition is a known gap.

2. **Inventory** — locate every `.ts` file under any `.opencode/tools/` directory (root + all subprojects). Exclude `node_modules`.

3. **Custom IPC Tool pattern** — verify `export default tool({...})` is present per PROT.TOOL.DEFINITION. Flag shebang CLI pattern, hybrid patterns, and plain `export default function` patterns.

4. **Read/write separation** — flag tools that both read from a DB or filesystem and write to one in the same `execute()`. Violates MAX.ORTHOGONALITY and PROT.TOOL.DEFINITION.

5. **`crashOnError()`** — verify `crashOnError()` appears in every `execute()` body, called near top before DB or filesystem operations.

6. **Import DAG** — tools import from `_lib/` or `../lib/` (shared library). Cross-tool imports excluded — flag them.

7. **Path prefix convention** — root tools import from `../_lib/` (underscore prefix); subproject tools import from `../lib/` (no underscore). Flag mismatches.

8. **Args described** — every arg in the schema must have `.describe()`. Flag bare `.string()`, `.number()`, `.boolean()` calls without description.

9. **Console output check** — flag `console.log`, `console.error`, `process.stdout.write`. Tools return strings for LLM consumption.

10. **Tool class annotation** — verify each tool file begins with `// @toolclass <CODE>` per PROT.TOOL.AUTOMATON. Read line 1 of each `.ts` file and match against the four archetypes (RECG, TRNS, GENR, SGNL). Flag missing or invalid annotations.

11. **Report per tool** — list each violation with `file:line`.

12. **Summarize** — pass/warn/fail count and compliance score.

**Gotchas**

- The `// @toolclass` annotation must be on line 1. Import statements and blank lines before it are violations
- Some subproject tools use simplified patterns (gear-specs `gear.ts`) — check Custom IPC Tool pattern. Documented exceptions permitted per PROT.TOOL.DEFINITION
- `crashOnError()` appears after destructuring or `const` declarations — use text search. Line-position matching excluded
- A tool that calls `queryAll` + `db.query(...).run(...)` is read+write — flag it. A tool that calls only `queryAll` is read-only — pass
- Imports from `../_lib/` in a subproject tool mean it's using the root shared lib instead of its local `../lib/` — flag as path prefix mismatch
- No IDENTITY.TOOL exists — identity definition is a known gap. Until created, audit against PROT.TOOL.* protocols and MAX.ORTHOGONALITY

**Rules**

- `export default tool({...})` required per PROT.TOOL.DEFINITION
- `execute()` calls `crashOnError()` — near top before DB/FS operations
- Imports from `_lib/` or `lib/` only — cross-tool imports excluded
- Root tools use `../_lib/` prefix; subproject tools use `../lib/` prefix
- Schema args require `.describe()` — bare `.string()`, `.number()` flagged
- Console output excluded — tools return strings
- `// @toolclass <CODE>` at line 1 — valid codes: RECG, TRNS, GENR, SGNL
- Report per tool: violations with `file:line`, then pass/fail/warn count
