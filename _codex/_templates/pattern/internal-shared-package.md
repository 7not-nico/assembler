---
id: PATTERN.INTERNAL.SHARED.PACKAGE
title: Internal Shared Package — One Home for Cross-Binary Logic
layer: pattern/
purpose: "Go binaries in one module share duplicated logic through an internal/ package — one home, thin cmd mains, both compile from the same source."
naming: internal-shared-package.md
tags: [pattern, morphism, go, internal, package, shared]
status: active
---
# INTERNAL-SHARED-PACKAGE.md

**Layer:** pattern/
**Naming:** `internal-shared-package.md` — code morphism, reusable structure.
**Composes with:** `pattern/shared-deps-binary.md`; derived from `study/` + `fixture/` proof.

## Morphism

Go binaries in one module share duplicated logic through an `internal/` package: the shared code lives once, `cmd/` mains stay thin, and both binaries compile from the same source with Go's internal-import guard.

## Structure

```text
_shared/
├── internal/codex/codex.go     ← shared walk-up (Root(base) → _codex)
└── cmd/
    ├── codexroot/main.go       ← thin: calls codex.Root(os.Args[1])
    └── bitacora/...            ← thin: calls codex.Root(exeDir) via write.go
```

Invariant: duplicated logic has exactly one home; `cmd/` entries carry dispatch only; `internal/` enforces the module boundary (no external import); a bug fix in the shared package heals every binary at once.

## Verification

Refactor a duplicated function into `internal/`, rebuild all binaries — identical behavior, one source of truth; `go vet ./...` + unit tests green; a change to the shared walk-up affects codexroot and bitacora identically.

## Instance

`internal/codex/codex.go` (2026-08-05) — the `_codex` walk-up was duplicated in `cmd/codexroot` and `cmd/bitacora`; extracted to one package, both refactored to thin mains, `codexroot .` + bitacora root both resolve identically.
