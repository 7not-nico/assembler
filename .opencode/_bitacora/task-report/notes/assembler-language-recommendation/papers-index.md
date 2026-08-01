# Papers Acquired — Assembler Architecture Validation

**Date**: 2026-07-24
**Location**: `findings/software-architecture/`
**Count**: 24 papers (42MB)

## Core Architecture

| Paper | Relevance | File |
|-------|-----------|------|
| **Functional Software Reference Architecture for LLM-Integrated Systems** (2501.12904) | Functional architecture pattern for LLM-integrated systems. Directly relevant to our MCP server architecture with functional core + imperative shell. | `2501.12904-functional-architecture-llm.pdf` |
| **Architectural Consistency in Plugin-Based Software Systems** (1510.08510) | Plugin architecture consistency checking. Validates our plugin-wrapper pattern for the Rust native addon. | `1510.08510-plugin-architecture.pdf` |
| **Quality Attributes Optimization of Software Architecture** (2301.07516) | Architecture optimization methodology. Relevant for evaluating our monolith-vs-modular tradeoffs. | `2301.07516-quality-attributes-architecture.pdf` |
| **Ports and Adapters / Microservices Architecture** (2512.08657) | Ports and adapters pattern applied to microservices. Maps to our hexagonal architecture with Rust core and Bun shell. | `2512.08657-ports-adapters-microservices.pdf` |

## Rust Language & Performance

| Paper | Relevance | File |
|-------|-----------|------|
| **Is Rust C++-fast? Benchmarking System Languages** (2209.09127) | **Foundational.** Benchmarks Rust against C++ on real-world tasks. Validates Rust's performance for our functional core. | `2209.09127-rust-benchmark.pdf` |
| **NPB-Rust: NAS Parallel Benchmarks in Rust** (2502.15536) | Parallel performance benchmarks in Rust. Validates Rust for compute-heavy vector search workloads. | `2502.15536-npb-rust-benchmarks.pdf` |
| **SACTOR: C to Rust with FFI Verification** (2503.12511) | **Foundational.** FFI-based verification for Rust. Directly relevant to our napi-rs FFI boundary. | `2503.12511-sactor-c-to-rust-ffi.pdf` |
| **Demystifying Compiler Unstable Feature Usage in Rust** (2310.17186) | Rust ecosystem stability analysis. Relevant for understanding Rust toolchain reliability vs Bun. | `2310.17186-rust-compiler-unstable-features.pdf` |
| **Translating C To Rust: Lessons from a User Study** (2411.14174) | Rust migration patterns. Relevant for our _lib/ TS → Rust porting strategy. | `2411.14174-translating-c-to-rust.pdf` |
| **Garbage Collection Makes Rust Easier to Use** (2110.01098) | Rust usability study. Validates Rust's memory safety advantages without GC overhead. | `2110.01098-garbage-collection-rust.pdf` |

## WebAssembly & Native Performance

| Paper | Relevance | File |
|-------|-----------|------|
| **Not So Fast: Analyzing WebAssembly vs. Native Code** (1901.09056) | **Foundational.** WASM is 30-50% slower than native. Validates our choice of napi-rs (.node native addon) over WASM for the Rust functional core. | `1901.09056-webassembly-vs-native.pdf` |
| **Wasure: WebAssembly Benchmarking Toolkit** (2602.05488) | Comprehensive WASM benchmarking methodology. Relevant for quantifying the WASM vs native tradeoff in our architecture. | `2602.05488-wasm-benchmarking.pdf` |

## Foundational Architecture Papers

| Paper | Relevance | File |
|-------|-----------|------|
| **Cockburn, Hexagonal Architecture (Ports and Adapters) — Original 2005** | **The canonical source.** Defines ports and adapters pattern. Our Rust lib = core hexagon, Bun shell = adapters. | `cockburn-hexagonal-architecture-2005.pdf` |
| **Cockburn, Hexagonal Architecture Explained (Book Preview)** | Practical implementation guide. Port/adapter boundaries, dependency inversion. | `cockburn-hexagonal-architecture-book.pdf` |
| **Cockburn, Hexagonal Architecture Budapest 2023 Slides** | Updated diagrams: provided vs required interfaces, driver patterns. | `cockburn-hexagonal-budapest-slides.pdf` |
| **Martin, The Clean Architecture (2012)** | **The canonical source.** Dependency Rule: source code dependencies point inward. Our .node binary is the innermost layer. | `martin-clean-architecture-2012.pdf` |

## Rust Bindings & FFI

| Paper | Relevance | File |
|-------|-----------|------|
| **Rust vs. C for Python Libraries: Evaluating Rust-Compatible Bindings Toolchains** (2507.00264) | Directly relevant — evaluates Rust FFI toolchains for use from a higher-level language. Same pattern as our napi-rs. | `2507.00264-rust-vs-c-python-bindings.pdf` |
| **&inator: Correct, Precise C-to-Rust Interface Translation** (2604.17261) | C-to-Rust FFI translation with precision guarantees. | `2604.17261-andinator-c-to-rust-ffi.pdf` |
| **Kernel-FFI: Transparent Foreign Function Interfaces** (2507.23205) | Transparent cross-language FFI. Validates our napi-rs boundary pattern. | `2507.23205-kernel-ffi-transparent-ffi.pdf` |

## Rust Language & Ecosystem

| Paper | Relevance | File |
|-------|-----------|------|
| **Rust: The Programming Language for Safety and Performance** (2206.05503) | Foundational Rust overview — safety guarantees + performance characteristics. | `2206.05503-rust-safety-performance.pdf` |
| **RustCompCert: A Verified and Verifying Compiler for Rust** (2602.07455) | Rust compiler verification — validates Rust's reliability for safety-critical lib code. | `2602.07455-rustcompcert-verified-compiler.pdf` |
| **NPB-Rust: NAS Parallel Benchmarks in Rust** (2502.15536) | Parallel performance benchmarks — validates Rust for compute-heavy vector search. | `2502.15536-npb-rust-benchmarks.pdf` |

## Supply Chain & Dependency Management

| Paper | Relevance | File |
|-------|-----------|------|
| **npm Security Issue Reporting** (2506.07728) | npm ecosystem vulnerabilities. Supports our decision to move lib deps away from npm/Bun. | `2506.07728-npm-security.pdf` |
| **Software Supply Chain Security** (2406.10109) | Secure design properties for software supply chains. Our single .node binary reduces attack surface. | `2406.10109-supply-chain-security.pdf` |

## Architecture Patterns

| Paper | Relevance | File |
|-------|-----------|------|
| **Architectural Patterns for Federated Learning Systems** (2101.02373) | Pattern language for distributed systems architecture. | `2101.02373-architectural-patterns-federated-learning.pdf` |

## Complete Inventory

| Count | Source | Papers |
|-------|--------|--------|
| 20 | arxiv | Software architecture, Rust, FFI, WASM, npm |
| 3 | Cockburn | Hexagonal architecture (2005 original + 2023/2024) |
| 1 | Martin | Clean architecture (2012) |
| **24** | **total** | **42MB** |

## How Papers Validate Our Architecture

| Architectural Decision | Validating Papers |
|----------------------|-------------------|
| Rust functional core | 2209.09127 (Rust=C++ speed), 2502.15536 (parallel perf) |
| Bun imperative shell | 2501.12904 (LLM functional architecture) |
| napi-rs over WASM | 1901.09056 (WASM 30-50% slower), 2602.05488 (WASM benchmarks) |
| Plugin wrapper pattern | 1510.08510 (plugin consistency), 2512.08657 (ports/adapters) |
| Cargo dependency management | 2310.17186 (Rust ecosystem stability) |
| One monolithic .node binary | 2301.07516 (architecture optimization) |

## Foundational Papers Acquired

| Paper | Status |
|-------|--------|
| Cockburn, "Hexagonal Architecture" (2005) | ✅ **Downloaded** |
| Cockburn, "Hexagonal Architecture Explained" (2024) | ✅ **Downloaded** |
| Martin, "Clean Architecture" (2012) | ✅ **Downloaded** |

## Foundational Papers Still to Acquire

| Paper | Location |
|-------|----------|
| Bernhardt, "Boundaries" (2012) talk | destroyallsoftware.com/talks/boundaries |
| Bernhardt, "Functional Core, Imperative Shell" (2012) screencast | destroyallsoftware.com — behind paywall |
| Gamma et al., "Design Patterns" (1994) | GoF book (commercial) |
| Evans, "Domain-Driven Design" (2003) | Book (commercial) |
