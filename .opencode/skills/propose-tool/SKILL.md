---
name: propose-tool
description: Use this skill when the user discusses a tool or plugin absent from .opencode/tools/ — it detects the absence and proposes creating it with full convention compliance
state-profile: hybrid
type: procedure
related: [SKL.AUDIT.TOOL]
patterns: [NEX.META.PROPOSAL, PROT.TOOL.DEFINITION, PROT.TOOL.AUTOMATON, REF.LIB.DIRECTORY.LAYER, MAX.ORTHOGONALITY, PAT.META.ENTITY.LIFECYCLE]
---

**Procedure**

When proposing a tool:

1. Infer tool name from discussion, glob `.opencode/tools/{name}.ts` — skip if exact match exists
2. Search via `read-selection --type patterns` and `read-selection --type protocols` — find relevant patterns and protocols the tool should reference (min: `PROT.TOOL.DEFINITION`, `PROT.TOOL.AUTOMATON`, `REF.LIB.DIRECTORY.LAYER`, `MAX.ORTHOGONALITY`, `PAT.META.ENTITY.LIFECYCLE`)
3. Determine the tool's automaton class per `PROT.TOOL.AUTOMATON`:
   - **RECG** — read-only, validates, returns pass/fail
   - **TRNS** — reads input tape, writes output tape
   - **GENR** — write-only, produces from internal state
   - **SGNL** — reads and writes shared state
4. Determine read/write scope per `MAX.ORTHOGONALITY` — if the tool would both read and write persistent state, propose two separate tools instead
5. When missing — propose creation to the user, include the generated tool file content
6. On confirmation — write `.opencode/tools/{name}.ts` using Custom IPC Tool pattern:

   ```typescript
   // @toolclass <CODE>
   import { tool } from "@opencode-ai/plugin"
   import { crashOnError } from "../_lib/errors"
    // — import lib modules only; cross-tool imports excluded

   export default tool({
     description: "<what this tool does>",
     args: {
       // — typed, all .describe() called
     },
     async execute(args) {
       crashOnError()
       // — tool logic, return string
     },
   })
   ```

7. Run `read-validate` and confirm zero errors on the new tool
8. Optionally run `SKL.AUDIT.TOOL` to confirm the new tool is CONFIRMED per `PAT.META.ENTITY.LIFECYCLE`

**Gotchas**

- The `// @toolclass` annotation must be on line 1 — imports and blank lines before it are violations
- Root tools import from `../_lib/` (underscore prefix); subproject tools import from `../lib/` (no underscore) — use the correct prefix for the project
- A tool that reads then writes the same data classifies as synchronizer (SGNL), transducer excluded (TRNS) — classify by automaton model, convenience excluded
- `crashOnError()` must be called at top of `execute()` before any DB or filesystem operations
- Every schema arg must have `.describe()` — the LLM reads these to understand parameters
- Tools return strings — `console.log` and `console.error` excluded
- Read/write separation applies to persistent state (DB, files) — input-to-output transformation excluded from write classification
- If a subproject tool follows a documented simplified pattern in its `AGENTS.md`, allow the exception

**Rules**

- Frontmatter: `name` + `description` + `state-profile` only
- Body order: Trigger → Procedure → Gotchas → Rules → See also
- Tool pattern: `export default tool({...})` with `crashOnError()` in `execute()`
- Imports from `_lib/` (root) or `lib/` (subproject) — cross-tool imports excluded
- Schema args require `.describe()` — LLM reads these for parameter understanding
- Console output excluded — return strings only
- `// @toolclass <CODE>` at line 1 — valid codes: RECG, TRNS, GENR, SGNL
- One direction per tool — split read/write into separate tools
- Post-creation verification — run `read-validate` before reporting complete

**See also**

- `PROT.TOOL.DEFINITION` — Custom IPC Tool protocol
- `PROT.TOOL.DEFINITION` — schema defaults need ?? fallback at point of use
- `PROT.TOOL.AUTOMATON` — automaton classification
- `REF.LIB.DIRECTORY.LAYER` — shared lib convention, import paths
- `MAX.ORTHOGONALITY` — component independence
- `PAT.META.ENTITY.LIFECYCLE` — propose + audit state machine that this skill instantiates
- `SKL.AUDIT.TOOL` — audit counterpart
