---
id: PRE.BUN.ONLY.RUNTIME
title: Bun Only — Deterministic Tool Execution
source: assembler
summary: Subproject tooling runs on Bun runtime. Control flow is linear. Failure terminates execution.
precept: Subproject tooling uses Bun runtime. Control flow linear — one path per operation. Failure terminates execution.
enforcement: Convention
tags: [tooling, runtime, bun, determinism, crash]
status: active
priority: 3
---

**Bun Only** — subproject tooling runs on Bun runtime. Control flow is linear. Failure terminates execution.

## Corollaries

- Tools execute via bun run
- Dependencies resolve through shared symlinks — verify-deps verifies integrity
- Verification uses bun -e
- Network operations use fetch()
- File operations use Bun.write() / Bun.file()
- Control flow follows one path per operation
- Failure calls die() — execution ends with actionable message

## Applicability

All assembler subproject tooling — any context where toolchain runs on Bun instead of Node or Deno. Does not apply to standalone scripts outside the assembler tooling ecosystem.
