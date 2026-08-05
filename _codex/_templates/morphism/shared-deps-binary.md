---
id: PATTERN.SHARED.DEPS.BINARY
title: Shared Deps Binary — One Compiled Primitive, Many Rings
layer: pattern/
purpose: "Code shared across rings compiles into parametrized Go binaries under _shared/, executed by each ring's deps layer."
naming: shared-deps-binary.md
tags: [pattern, morphism, shared, deps, go]
status: active
---
# SHARED-DEPS-BINARY.md

**Layer:** pattern/
**Naming:** `shared-deps-binary.md` — code morphism, reusable structure.
**Composes with:** `pattern/wrapper-delegation.md`; derived from `study/` + `fixture/` proof.

## Morphism

Code shared across rings compiles into parametrized Go binaries under `_shared/`; each ring's deps layer executes them, so shared logic exists once, in one language.

## Structure

```text
_shared/go.mod                — module templates-shared
_shared/cmd/{name}/main.go    — one parametrized binary per primitive
_shared/bin/                  — build output (gitignored); go build -o bin/ ./cmd/...
shell/deps/paths.sh           — walk-up resolves _shared/bin, execs codexroot
instantiator/deps/browser.sh  — fixed depth, execs portup
```

Invariant: shared logic lives in Go only; bash deps carry resolution + invocation, never the algorithm; binaries stay build artifacts out of git.

## Verification

`go vet` + `gofmt` clean before commit; each binary's contract tested directly (relative arg, no-arg usage exit 2, missing-input exit 1); a consumer tool re-probed after a rewire; byte-wise behavior matches the replaced bash implementation.

## Instance

`codexroot`, `portup`, `slugify` (2026-08-05) — commits `5cd1ff8` + `c328981`; `codexroot` fixes the relative-arg walk; `slugify` collapses three bash/JS implementations into one.
