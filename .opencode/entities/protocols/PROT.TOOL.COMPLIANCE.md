---
id: PROT.TOOL.COMPLIANCE
title: "Generated Tool Compliance — Six Constraints for Scaffolded Tools"
source: NEX.TOOL.SEQUENCE
related: [PROT.TOOL.DEFINITION, PROT.TOOL.AUTOMATON]
summary: "Every DB-backed project derives operational tools from manifests and schema via a deterministic process. Generated tools must satisfy six compliance constraints: crashOnError(), .describe(), return string, // @toolclass, read/write separation, no console.log."
protocol: "Operational tools are generated from manifests and schema through a deterministic scaffolding process. Each generated tool must meet six compliance constraints derived from PROT.TOOL.DEFINITION, PROT.TOOL.AUTOMATON, and audit-tools checks."
enforcement: Sealed
status: draft
priority: 4
tags: [tooling, compliance, generation, quality, audit, convention, scaffolding]
---

Tools produced by scaffolding must meet the same quality standards as hand-written tools. Six mandatory constraints close the gap between generated and hand-crafted tools.

## Process

1. **Domain** — project's domain manifest defines what the project captures. Write to `.opencode/manifests/domain.md`.
2. **Entities** — from domain, derive entity manifest. Write to `.opencode/manifests/entities.md`.
3. **Properties** — from entities, derive properties manifest with field types. Write to `.opencode/manifests/properties.md`.
4. **Tools** — consume entities manifest, properties manifest, and `db.sql` schema. Generate operational tools that satisfy all six compliance constraints. Optional for schema-only projects.
5. **Deterministic scaffolding** — same manifests produce identical tools every run.

## Protocol

1. **Use `crashOnError()` in every execute body** — placed near the top, before any DB or filesystem operations. From `PROT.TOOL.DEFINITION` rule 8.
2. **Describe every schema argument with `.describe()`** — bare `.string()`, `.number()`, or `.boolean()` calls without description are violations.
3. **Return a string for LLM consumption** — tools `return` strings. `console.log`, `console.error`, and `process.stdout.write` are violations.
4. **Annotate at line 1 with `// @toolclass <CODE>`** — CODE is one of RECG, TRNS, GENR, SGNL. From `PROT.TOOL.AUTOMATON` rule 6.
5. **Separate read from write per tool** — tools read OR write per `execute()`, one direction per tool.
6. **Import only from `lib/` or `_lib/`** — route all cross-tool concerns through shared lib modules. From `REF.LIB.DIRECTORY.LAYER`.

## Gotchas

- Tool generation skips a step: Run all prior steps in order — each step depends on the previous step's manifest (Manifests for a previous step absent)
- Generated tool missing `crashOnError()`: Add `crashOnError()` as first call in `execute()` (Execute body has no `crashOnError()` call)
- Generated tool missing `.describe()` on arg: Add `.describe("description of what this arg expects")` (Schema arg call without `.describe()` following it)
- Generated tool uses `console.log` instead of `return`: Replace with `return` — the LLM reads the return value (Tool file contains `console.log()` or `console.error()`)
- Generated tool missing `// @toolclass` at line 1: Add `// @toolclass <CODE>` as line 1 before any imports (Line 1 of tool file lacks `// @toolclass <CODE>`)
- Generated tool reads and writes in same execute: Split into two tools — one RECG (read), one TRNS or GENR (write) (Both `db.query(...).all()` and `db.query(...).run()` in same function)
- Entity routing mismatch in generated tool: Use ID prefix routing from SPEC.ENTITY.ROUTING.TABLE (Generated tool uses wrong table name for an entity prefix)

## Enforcement

`audit-tool` verifies generated tools against the six compliance constraints on every push. Generated tools that fail audit are rejected. The scaffolding tool is responsible for generating compliant output; the audit tool verifies it.

## Applicability

All generated `.opencode/tools/*.ts` files in any AMANDA project. The constraints apply regardless of whether tools are hand-crafted or generated. Excluded for projects without a database backend.

## See also

- `PROT.TOOL.DEFINITION` — Custom IPC Tool pattern, source of constraints 1, 2, 3
- `PROT.TOOL.AUTOMATON` — tool classification, source of constraint 4
- `REF.LIB.DIRECTORY.LAYER` — lib path convention, implicit in constraint 6
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix routing for entity tables
- `SKL.AUDIT.TOOL` — enforcement tool
- `bootstrap-db` skill — pipeline steps 1–3
- `scaffold-tools` skill — pipeline step 4 implementation
