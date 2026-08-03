---
description: Anchor every task to live skills — entity context, research, reasoning, and active tool families
subtask: true
---

Anchor each task to the live skill set:

1. **Query entity context first** — call `semantic-dispatcher` (routes to `semantic_search` via mcp-semantic) before work; read live MAX.*, SPEC.*, PROT.*, RUL.* in ring order
2. **Run research** — use `search-dispatcher` (routes to `use-exa` / `use-parallel-search`), `workflow-dispatcher` → `use-context-seven` for library docs, `playwright-dispatcher` for browser work (routes to nested `use-playwright-*` modes); gate CAPTCHAs per `RUL.CAPTCHA.GATE`
3. **Apply reasoning** — match `reason-quantitative` or `reason-verbal` to task mode; run `reason-invariants` before invariant-bearing work
4. **Consult languages** — use `knowledge-languages` (ref/ruby.md) for functional Ruby reference; route other languages via its dispatcher
5. **Compose bash flows** — route via `workflow-dispatcher` → `manage-bash-flows` for scripting, `structure-stdout` for pipe contracts, `survey-scripts` for surveys, `bitacora-workflow` for bookkeeping
6. **Study new ground** — open uncharted topics via `study-foundations`; reshape skills via `refactor-skill`
