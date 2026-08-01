---
id: PROT.TOOL.SCHEMA.DEFAULT
title: "Schema Defaults — Questionmark-Questionmark Over Exclamation for Runtime Fallback"
source: assembler
related: []
summary: "Schema defaults are LLM guidance, separate from runtime enforcement. Every handler applies qmark-qmark fallback for args with .default() or .optional()."
protocol: "Schema .default() documents the expected value for the LLM caller. Runtime fallback is absent from schema defaults. Each handler applies qmark-qmark at point of use."
enforcement: Convention
status: active
priority: 4
tags: [tooling, schema, args, gotcha, convention, safety]
---

`.default()` documents the expected value for the LLM caller. The handler uses `??` at point of use.

## Protocol

1. **Use `.default(x)` in the schema** — documents the expected value for the LLM caller. The LLM reads `.default()` as guidance for correct invocation.

2. **Apply `??` fallback in `execute()`** — `const foo = args.foo ?? fallback`. The runtime handler guards every arg that has a default or optional modifier.

3. **Apply `??` on every `.default()` arg and every `.optional()` arg** — `args.foo` with non-null assertion silently passes `undefined` through to runtime. `??` is the reliable fallback.

4. **Reserve non-null assertion for unconditionally required args** — args declared as `tool.schema.string()` with no `.optional()` and no `.default()` are genuinely required. All other args need `??`.

## Rationale

- Tool arg schema serves two audiences with different guarantees: the LLM caller reads `.describe()` + `.default()`, the runtime handler receives raw values
- `@opencode-ai/plugin` IPC layer may pass raw JSON without Zod parsing — `.default()` declared in the schema stays absent from runtime execution. Apply `??` fallback in the handler body to guarantee defined values.
- This is a schema-first IPC characteristic, separate from a framework bug — `.default()` is a suggestion to the caller, excluded from transformation at the boundary
- `??` is the only reliable runtime fallback — always defined, always applied, always works regardless of how the IPC layer passes args

## Gotchas

| # | Antipattern | Detection | Redirect |
|---|-------------|-----------|----------|
| 1 | Non-null assertion on arg with `.default(x)` | `args\.\w+` with non-null assertion in tool plus `.default(x)` in same file's schema | Use `args.x ?? fallback` — non-null assertion passes `undefined` through silently at runtime |
| 2 | Non-null assertion on `.optional()` arg | `args\.\w+` with non-null assertion in tool plus `.optional()` in schema | Use `args.x ?? fallback` — non-null assertion skips the undefined check, `??` guarantees a defined value |
| 3 | No fallback anywhere, assuming `.default()` applied | Runtime `undefined` error from an arg that had `.default()` declared in schema | Add `?? fallback` in handler body — `.default()` is LLM guidance, excluded from runtime assignment |

## Enforcement

Detection is machine-checkable via ripgrep:

Detection uses ripgrep to find `args.` access patterns in `.opencode/tools/` then cross-references against schema definitions with `.default()` in the same files.

Every match of `args.foo` with non-null assertion where `foo` has a `.default(fallback)` in the schema is a violation. Every match where `foo` has `.optional()` without `??` is a potential violation.

## Applicability

Every AMANDA project with `.opencode/tools/` using `@opencode-ai/plugin` arg schemas. Also applies to any schema-first arg framework where the IPC boundary may skip Zod parsing.

## See also

- `PROT.TOOL.DEFINITION` — tool structure that creates the schema layer
- `PROT.LIB.CONTRACT.VIOLATIONS` — antipattern catalog for lib modules (related detection strategy)
- `PROT.SCHEMA.SQLITE.BINDING` — similar principle: bind to the result method, excluded from the query
