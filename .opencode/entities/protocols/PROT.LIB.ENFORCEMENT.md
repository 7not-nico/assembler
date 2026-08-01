---
id: PROT.LIB.ENFORCEMENT
title: "Contract Auto-Enforcement — Lifecycle Hooks for Module Integrity"
source: NEX.LIB.STACK
related: [PROT.LIB.CONTRACT, PROT.PLUGIN.LIFECYCLE, PROT.TOOL.HOOKS]
summary: "Module contract completeness enforced automatically via lifecycle hooks. Detection in pure lib, enforcement in plugin hooks. Covers agent Write/Bash tool writes via tool.execute.before; manual editor saves have no pre-write enforcement."
protocol: "Detection logic lives in _lib/audit-{domain}.ts (pure, no I/O). Enforcement hooks in plugins/{domain}.ts (IO). tool.execute.before catches violations at agent write time, before the file is saved. tool.execute.after catches post-sync violations. Manual editor saves have no pre-write hook — only post-save detection via file.edited. client.app.log() reports with severity levels."
enforcement: Formality
status: draft
priority: 3
tags: [lib, module, contract, enforcement, plugin, validation, convention]
---

Module contract completeness (exports, purity, dependencies) checked automatically on every file write and post-sync. Pure detection logic separated from lifecycle hook wiring.

## Protocol

1. **Detection logic in _lib/** — a pure module at `_lib/audit-{domain}.ts` accepts structured data (file path, content lines), checks contract completeness, and returns a list of violations. No I/O, no side effects.

2. **Enforcement hooks in plugins/** — the plugin at `plugins/{domain}.ts` imports the detection logic and wires lifecycle hooks. Plugin handles I/O only (filesystem reads, logging).

3. **`tool.execute.before` on agent write tools** — fires when the agent invokes a Write/Bash tool that modifies a lib file. Plugin reads the target file path from `input.args.filePath`, runs detection, and throws if violations found. Catches drift at the earliest possible moment for agent-driven writes — before the file is persisted. Does NOT fire on opencode editor manual saves — see §7 for the manual edit gap.

4. **`tool.execute.after` on sync/batch tools** — fires after sync or batch operations. Re-scans all relevant lib files and logs any violations introduced by the operation.

5. **`client.app.log()` reporting** — violations logged with severity:
   - `error` — missing required declaration (exports, purity, depends-on absent)
   - `warn` — mismatch between declared and actual exports (undocumented export or ghost declaration)

6. **Hooks-only** — no `tool:` registration. Companion skill omitted per `PROT.PLUGIN.LIFECYCLE` §3.

7. **Manual editor save coverage gap** — `file.edited` fires after the save, not before. Manual editor saves have no pre-write enforcement hook. Violations introduced by manual edits are detected post-facto via `file.edited` + `tool.execute.after` (on next sync). For pre-save enforcement on manual edits, no plugin hook is available. Use linting or editor integrations as a separate enforcement path.

## Exception

Two agent-tool hooks (`tool.execute.before` + `tool.execute.after`) for complementary timing: pre-write for agent Write/Bash tools, post-sync for batch operations. Both target the same trigger source (agent tool execution) at different phases. This is distinct from the `file.edited` + `tool.execute.after` pattern in `PROT.PLUGIN.LIFECYCLE` which targets different trigger sources (editor saves vs agent tools).

## Gotchas

- False positive on intermediate save: Accept — clean on next save. Tool chains write once per invocation (Partial file content before multi-cursor edit completes)
- Hook ordering conflict with other validation plugins: Use priority convention — validation runs earliest (Two plugins fire on same `tool.execute.before` event)
- Log noise at scale: Use `warn` for mismatch (actionable), log only changed files, not full scan (Every lib file edit logs violations)

## Enforcement

Convention — peer review on new validation plugins that implement auto-enforcement. The protocol declares the separation (pure lib + IO plugin) and the hook mapping. Specific rules checked are defined in the referencing protocol (e.g., `PROT.LIB.CONTRACT` for contract completeness).

## See also

- `PROT.LIB.CONTRACT` — the contract being enforced
- `PROT.PLUGIN.LIFECYCLE` — validation plugin pattern (exception for two hooks)
- `REF.LIB.PURITY.BOUNDARY` — pure vs IO separation definitions
- `REF.LIB.DEPENDENCY.DIRECTION` — dependency graph rules
- `PROT.PLUGIN.LIFECYCLE` — concrete application pattern
