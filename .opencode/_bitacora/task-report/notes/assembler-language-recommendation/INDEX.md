# Language Recommendation — Assembler Project

**Date**: 2026-07-24
**Status**: Final — Architecture Sealed
**Scope**: Language choice for MCP servers, CLI tooling, and binary distribution

## Report Structure

| File | Content |
|------|---------|
| `findings-papers.md` | Papers, benchmarks, and web research |
| `patlib-guidance.md` | Relevant maxims, protocols, and patterns from patlib |
| `comparison-data.md` | Quantitative comparison across Go, Rust, TypeScript/Bun |
| `recommendation.md` | Final recommendation with rationale |
| `architecture-mapping.md` | MAX.CODE.LAYERS + MAX.ENTITY.ONTOLOGY mapping |
| `execution-plan.md` | P0-P5 execution phases |
| `imperative-shell-functional-core.md` | Bun/Rust boundary, error flow, crash prevention |
| `dependency-lessons.md` | Bun dep failure in trump-voices, Cargo solution |
| `errors-and-conclusions.md` | All errors, decisions, timestamps |
| `papers-found.md` | Academic papers and technical resources validating architecture |

## Architecture Summary

```
MAX.CODE.LAYERS                    MAX.ENTITY.ONTOLOGY
─────────────────                  ────────────────────
Rust (napi-rs)  → Functional Core  → PURE ring (innermost)
Bun (TS)        → Imperative Shell → Outer rings + tool classes
```

## Context

Assembler is a TypeScript/Bun project with ~43 lib files, ~23 tool files, and 12+ MCP servers.
Current runtime per MAX.BUN.ONLY is Bun for tools. Rust (napi-rs) added for lib binary.
