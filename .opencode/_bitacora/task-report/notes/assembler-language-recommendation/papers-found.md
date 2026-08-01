# Papers & Resources Found

**Date**: 2026-07-24
**Query**: Resources validating our architecture: Rust napi-rs functional core + Bun imperative shell

## Architecture Pattern — Functional Core, Imperative Shell

| Resource | Type | Relevance |
|----------|------|-----------|
| Gary Bernhardt, "Functional Core, Imperative Shell" (2012) | Screencast | **Original pattern definition.** Rust = functional core. Bun = imperative shell. Precedent for our exact split. |
| Gary Bernhardt, "Boundaries" (2012) | Talk | **Dependency Rule.** Core never calls shell. Shell calls core. Our Rust `.node` has zero Bun imports. |
| Google Testing Blog, "Simplify Your Code: Functional Core, Imperative Shell" (2025) | Article | Industry adoption at Google scale. Validates the pattern for production systems. |
| Kenneth Lange, "The Functional Core, Imperative Shell Pattern" (2021) | Article | Practical guide. Core = pure functions. Shell = I/O, DB, networking. Maps directly to our 7-layer MAX.CODE.LAYERS. |
| functional-architecture.org, "Functional Core, Imperative Shell" | Reference | "The core never calls the shell." Validates our Rust lib has no Bun dependency. |

## Native Addon Pattern — napi-rs

| Resource | Type | Relevance |
|----------|------|-----------|
| HireNodeJS, "Node.js + NAPI-RS in 2026: Native Rust Addons for Production" (2026) | Guide | **Direct validation.** "NAPI-RS has become the default way teams ship native code in Node.js." esbuild, swc, Turbopack, sharp all use this pattern. |
| napi.rs official site | Docs | Architecture: `#[napi]` attribute → C ABI → V8 N-API. Generated `.d.ts` types. |
| rs4ts.dev, "Node.js Native Addons with napi-rs" | Guide | Benchmark: Rust fibonacci 57.6ms vs JS 1047.8ms (18x). FFI overhead ~50-200ns per crossing. |
| GitHub, "napi-rs/napi-rs" | Repository | 7K+ stars. Stable N-API ABI. Bundled SQLite via `tokio-rusqlite`. ONNX via `ort` crate. |
| DeepWiki, "napi-rs Architecture" | Docs | Production patterns: GitHub Actions multi-platform CI, prebuilt binaries via npm optionalDependencies. |

## Cross-Language FFI

| Resource | Type | Relevance |
|----------|------|-----------|
| Li et al., "Kernel-FFI: Transparent Foreign Function Interfaces" (arxiv 2507.23205, 2025) | Paper | **Academic validation.** Cross-language FFI is active research. Addresses the exact problem we're solving: transparent calls across language boundaries. |
| stepfunc/oo_bindgen, "Cross-Language FFI" (DeepWiki) | Guide | FFI design patterns for multi-language systems. Validates our monolithic `.node` approach over micro-services. |
| "Programming Language Efficiency Deep Dive" (2026) | Article | "The FFI Tax" — boundary crossing costs 1-5μs. Batch operations. Our approach: one `.node` binary, batch calls. |

## Monolith vs Modular

| Resource | Type | Relevance |
|----------|------|-----------|
| Rodrigues et al., "Performance Comparison of Monolith and Microservice Architectures" (Springer ECSA 2023) | Paper | **Academic comparison.** Monolith lower latency (no inter-service overhead). Simpler debugging. Validates our single `.node` binary decision. |
| Fellipe Juncal, "Microservices vs. Monolith: Performance, Scalability, and Cost Analysis" (2025) | Analysis | Cost analysis: monolith lower infra cost. Simpler CI/CD. Our tools import 2-5 libs each — monolithic binary serves all. |
| "Monoliths vs Microservices: Why Startups Should Think Twice" (DEV, 2025) | Article | Modular monolith (our approach) is the recommended starting point. |

## How Each Validates Our Architecture

| Our Decision | Paper/Resource | Validation |
|-------------|---------------|------------|
| Rust for functional core | Bernhardt "FCIS" (2012) | Core is pure functions, no I/O. Core never calls shell. |
| Bun for imperative shell | Google Testing Blog (2025) | Shell handles I/O, registers tools, formats output. |
| napi-rs for Rust-Bun bridge | HireNodeJS NAPI-RS Guide (2026) | Industry standard. esbuild, swc, sharp all use it. |
| One monolithic `.node` binary | ECSA 2023 Monolith paper | Lower latency. Simpler debugging. No inter-service overhead. |
| Plugin loads binary in-process | napi-rs Architecture | `require(".node")` is native to Node/Bun. Zero deployment complexity. |
| Cargo for dependency management | NAPI-RS production patterns | Deterministic resolution. Bundled native deps. No runtime dep resolution. |
| Error handling in Rust, not Bun | Kernel-FFI paper | FFI boundary as safety barrier. Rust Result → JS Error → user message. |

## To Acquire

- [ ] Bernhardt, "Functional Core, Imperative Shell" (screencast) — destroyallsoftware.com
- [ ] Bernhardt, "Boundaries" (talk) — destroyallsoftware.com
- [ ] Li et al., "Kernel-FFI" — arxiv 2507.23205
- [ ] Rodrigues et al., "Performance Comparison of Monolith and Microservice" — Springer ECSA 2023
