---
id: ILL.LIB.ENFORCE
title: "Contract Enforce — Lifecycle Hook Walkthrough"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of contract auto-enforcement for ludoteca lib modules — detection in lib, enforcement in plugins, hooks on write and sync."
illustration: "A developer edits a lib module in ludoteca. The plugin fires tool.execute.before, runs auditContract, and rejects the save if the contract is incomplete."
illustrates: [PROT.PLUGIN.LIFECYCLE]
tags: lib,contract,enforcement,walkthrough,hook,audit
related: [PROT.LIB.CONTRACT, PROT.PLUGIN.LIFECYCLE, ILL.LIB.CONTRACT.BLOCK]
---
## Rationale

Every lib module declares `// exports:`, `// purity:`, and `// depends-on:`. Without auto-enforcement, a new file or edit could miss a contract declaration — drift introduced silently until the next manual audit. Lifecycle hooks catch this before the file is persisted.

Ludoteca has 55 lib modules across three purity levels. All modules declare `// exports:`, `// purity:`, and `// depends-on:`. Without auto-enforcement, a new file or edit could miss a contract declaration — drift introduced silently until the next manual audit.

## Walkthrough

1. A developer edits a lib module in `ludoteca/.opencode/lib/`. The file is in the write buffer, not yet persisted.

2. The `tool.execute.before` hook fires on the `write` tool. The plugin reads `output.args.filePath`. If the path matches `.opencode/lib/*.ts`, it calls `auditContract(content, filename)`.

3. The pure detection function in `ludoteca/.opencode/lib/audit-contracts.ts` parses the file content and runs five checks:

   - Missing `// exports:` — error if no exports declaration in first 10 lines
   - Missing `// purity:` — error if no purity declaration
   - Missing `// depends-on:` — error if no dependency declaration
   - Undocumented export — warn if `export function` exists but not in `// exports:`
   - Ghost export — warn if name in `// exports:` but no matching `export` statement

4. If violations are found, the plugin throws an error with the violation list. The write is rejected — the file is not saved. The developer sees the error, fixes the contract, and retries.

5. If no violations are found, the write succeeds. After `ludoteca_sync` or `ludoteca_normalize_yaml`, the `tool.execute.after` hook rescans all lib files and logs any violations introduced by the operation.

## Key insight

The enforcement catches drift at the earliest possible moment — before the file is persisted. Pure detection logic in `lib/audit-contracts.ts` is testable without DB or filesystem. The plugin handles I/O only. Two hooks cover both write-time drift and batch-import drift.

## See also

- `PROT.PLUGIN.LIFECYCLE` — contract auto-enforcement pattern
- `PROT.PLUGIN.LIFECYCLE` — abstract enforcement protocol
- `PROT.LIB.CONTRACT` — module contract format
- `ILL.LIB.CONTRACT.BLOCK` — contract declaration walkthrough
- `PROT.PLUGIN.LIFECYCLE` — validation plugin pattern
