---
id: PATTERN.COMPOSITION.SHARED.BINARY
title: Shared Binary Composition — One Module, One cmd, Gitignored Bin
layer: pattern/composition/
purpose: "A shared primitive composes as a single-main Go binary: declare, implement, build, ignore, consume, verify."
naming: shared-binary-composition.md
tags: [pattern, composition, morphism, binary, go]
status: active
---
# SHARED-BINARY-COMPOSITION.md

**Layer:** pattern/composition/
**Naming:** `shared-binary-composition.md` — code morphism, reusable structure.
**Composes with:** `pattern/shared-deps-binary.md`; derived from `study/` + `fixture/` proof.

## Morphism

A shared primitive composes as a single-main Go binary: one module, one `cmd/{name}` package, positional args, explicit exit codes, and purity — built to a gitignored `bin/`, executed by ring deps layers.

## Composition

```text
step 1  declare    _shared/go.mod                 — module templates-shared (one module, N binaries)
step 2  implement  _shared/cmd/{name}/main.go     — the declaration contract (below)
step 3  build      cd _shared && go build -o bin/ ./cmd/...
step 4  ignore     .gitignore — **/_shared/bin/   — binaries stay build artifacts
step 5  consume    deps/{paths,browser}.sh exec "$SHARED_BIN/{name}" "$@"
step 6  verify     go vet ./... && gofmt -l; contract tests; consumer re-probe
```

## Declaration contract

Every binary declares its contract in the header comment and enforces it in `main`:

```go
// Package main — {name} {one-line purpose}.
// Usage: {name} {arg}
// {behavior + failure mode}. Pure: no side effects.
package main

func main() {
    if len(os.Args) != 2 {           // arity guard: exactly one positional arg
        fmt.Fprintln(os.Stderr, "usage: {name} {arg}")
        os.Exit(2)                   // 2 = usage
    }
    arg := os.Args[1]                // positional; no env-file model
    // path args: filepath.Abs + filepath.EvalSymlinks before walking
    // result  → stdout (one line)
    // failure → stderr (hint line)
    // exit 0 success | 1 failure | 2 usage
}
```

Invariant: one binary, one responsibility; the header states usage, behavior, and purity; bash deps never re-implement the algorithm.

## Consumer resolution

```text
shell/deps/paths.sh        — walk-up: resolve_shared finds _shared/bin from own location
instantiator/deps/paths.sh — fixed depth: ../../_shared/bin (never copies into dives)
instantiator/acquire-game.sh — direct exec of _shared/bin/slugify (no shell shim)
```

## Verification

`go vet ./...` clean and `gofmt -l` empty before commit; each contract exercised directly — success prints one stdout line and exits 0, failure prints stderr and exits 1, wrong arity prints usage and exits 2; a consumer tool re-probed after any rewire.

## Instance

`codexroot` (ancestor resolve, `Abs`+`EvalSymlinks` walk), `portup` (CDP `/json/version` probe, 2s timeout), `slugify` (byte-wise ASCII dash-slug) — 2026-08-05, commits `5cd1ff8` + `c328981`; `slugify` replaces three bash/JS implementations with one contract.
