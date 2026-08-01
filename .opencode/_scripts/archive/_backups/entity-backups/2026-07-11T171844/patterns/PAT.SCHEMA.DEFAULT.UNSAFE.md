---
id: PAT.SCHEMA.DEFAULT.UNSAFE
title: Schema Defaults Are Not Runtime Fallbacks — ?? Over !
source: assembler
summary: Schema .default() documents the expected value for the LLM consumer but does not guarantee runtime fallback. Handlers must defensively apply ?? at point of use.
principle: Separate schema concerns from runtime concerns. Declare defaults for the caller (LLM guidance); enforce them in the handler with an explicit ?? fallback.
enforcement: Convention
tags: [tooling, schema, args, gotcha, convention, safety]
patterns: [PAT.PLUGIN.IPC.TOOL, PAT.LIB.GOTCHA, PAT.SQLITE.PARAM.BINDING, PAT.GENERATED.COMPLIANCE]
terms: [TERM.GENERATED.TOOL]
status: active
priority: 4
---

**Schema defaults are declarative metadata for the consumer, not runtime enforcement.** The handler must guard against `undefined` at point of use.

## Context

Tool argument schemas serve two audiences with different guarantees:

| Audience | Reads | Guarantee |
|----------|-------|-----------|
| **LLM consumer** (caller) | `.describe()` + `.default()` | Docs for correct invocation |
| **Runtime handler** (execute) | `args.*` values | Values arrive as provided — defaults may not propagate |

`@opencode-ai/plugin` tool schemas use Zod under `tool.schema`. Zod `.default()` applies at parse time, but the OpenCode IPC layer may pass raw JSON without Zod parsing — the declared default never executes. The arg arrives as `undefined`.

This is not a framework bug — it is a fundamental property of schema-first IPC: the default is a suggestion to the caller, not a transformation applied at the boundary.

## Rules

- Use `.default(x)` in the schema — it documents the expected value for the LLM
- Always follow with `??` in `execute()`: `const foo = args.foo ?? fallback`
- Only omit `??` when the arg is unconditionally required (`query: tool.schema.string()` with no `.optional()`) and `!` is the correct assertion
- Never use `args.foo!` (non-null assertion) on an arg with `.default()` or `.optional()` — the assertion silently passes `undefined` through to runtime

## Detection

```bash
# Find all non-null assertions on tool args — likely bugs
rg 'args\.\w+!' .opencode/tools/

# Cross-reference against schema definitions with .default()
rg '\.default\(' .opencode/tools/
```

Every match of `args.foo!` where `foo` has a `.default(fallback)` in the schema is a bug. Every match where `foo` has `.optional()` without `??` is a potential bug.

## Gotchas

| # | Antipattern | Detection | Fix |
|---|-------------|-----------|-----|
| 1 | `args.x!` on arg with `.default(x)` | `args\.\w+!` in tool + `.default(x)` in same file's schema | `args.x ?? fallback` |
| 2 | `args.x!` on `.optional()` arg | `args\.\w+!` in tool + `.optional()` in schema | `args.x ?? fallback` or early guard |
| 3 | No fallback anywhere, assuming `.default()` applied | Runtime `undefined` error | Add `??` in handler body |

## Applicability

Every AMANDA project with `.opencode/tools/` using `@opencode-ai/plugin` arg schemas — currently ludoteca, palestra, and future plugin-IPC projects. Also applies to any schema-first arg framework where the IPC boundary may skip Zod parsing.

## See also

- PAT.PLUGIN.IPC.TOOL — base pattern for plugin IPC tool architecture
- PAT.LIB.GOTCHA — antipattern catalog for lib modules (related detection strategy)
- PAT.SQLITE.PARAM.BINDING — similar principle: "don't trust the API to do what you expect"
- PAT.GENERATED.COMPLIANCE — generated tools require schema compliance; default safety intersects with arg description requirements
- TERM.GENERATED.TOOL — scaffolded tool structure that inherits this convention
