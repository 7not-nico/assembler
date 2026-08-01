---
id: PRE.RUBY.ONLY.RUNTIME
title: Ruby Only — Zero-Dependency Analysis Scripts
source: assembler
summary: "scripts/ runs on Ruby 3.x stdlib only. No gems, no other runtimes. Zero dependencies means any machine with Ruby runs any script immediately."
precept: "scripts/ uses Ruby 3.x stdlib only — yaml, json, pathname. No Gemfile, no gems, no Bundler. No Bun, no TypeScript, no Python. Zero-dependency scripts run on any machine with Ruby. Failure to follow means the script cannot execute in the scripts/ context."
enforcement: Convention
tags: [tooling, runtime, ruby, determinism, zero-dependency]
status: active
priority: 2
---

**Ruby Only** — scripts/ uses Ruby 3.x stdlib only. No gems, no other runtimes.

## Corollaries

- Every executable script uses `#!/usr/bin/env ruby` shebang
- All deps are stdlib requires — `require "yaml"`, `require "json"`, `require "pathname"`
- No `Gemfile` or gems in `scripts/` directory tree
- Analysis logic lives in Ruby, not shell. Shell `#!/bin/sh` for trivial wrappers only
- No Bun, no Node, no TypeScript, no Python in scripts/
- `package.json` and `tsconfig` belong in root or subproject `.opencode/`

## Applicability

All files under `scripts/`. Does not apply to root tools (use `PRE.BUN.ONLY.RUNTIME`) or subproject tools (use their own runtime convention).
