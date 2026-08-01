---
id: ILL.BUN.TROUBLES
title: "Bun Only — Antipatterns That Motivated the Maxim"
source: PROT.TOOL.RUNNER
summary: "Five real antipatterns from the findings project where mixing bash with Bun caused failures — retry loops, pipe leaks, curl divergence, per-project install drift, and grep path brittleness."
illustration: "The findings project mixed bash and Bun runtime across tools, deps, verification, and pipeline wiring — every mixing point caused a distinct failure class resolved by PRE.BUN.ONLY.RUNTIME."
illustrates: [PRE.BUN.ONLY.RUNTIME]
tags: antipattern,bun,bash,tooling,failure,motivation
related: [REF.TOOL.NODE_MODULES.SHARED, REF.LIB.DIRECTORY.LAYER]
---
## Context

The findings project needed a paper catalog pipeline: scan files, enrich via arxiv API, load into DB. Early iterations mixed bash calls with Bun runtime. Every mixing point produced a distinct failure class — subtle, silent, and data-corrupting. Abidi et al. catalog six design antipatterns for multi-language systems [1]; Neitsch et al. document build patterns and antipatterns for multilanguage software [2]. Our troubles mirror these findings exactly.

## Walkthrough

### Trouble 1: Per-project `bun install` instead of `verify-deps`

The findings subproject ran `bun install` locally, creating its own `node_modules/`. Root already had a canonical store. Versions diverged: root had `js-yaml` v4.2, findings had v4.5. Bun module resolution walked upward — root copy shadowed. Runtime errors appeared: `YAML.load()` returned different types. Silent. Intermittent. Reproducible only from the findings directory.

Neitsch et al. [2] document build system antipatterns in multilanguage software — this is a dependency management antipattern in the build chain. Jafari et al. [3] empirically study dependency smells in JavaScript projects, showing version drift between package manager instances produces hard-to-diagnose bugs.

The fix: delete findings `node_modules/`, symlink to root, verify via `verify-deps --repair`. Per `REF.TOOL.NODE_MODULES.SHARED`.

### Trouble 2: `curl` for arxiv API alongside `fetch()`

Early scan pipeline used `curl` for one API call and Bun `fetch()` for another. `curl` failures produced non-JSON output that flowed into downstream parsers. The `curl` call had no error handling — only `|| true` swallowed failures. `fetch()` had proper `response.ok` checks. `curl` errors bypassed `fetch()` entirely. Two HTTP clients, two error models, one pipeline.

Abidi et al. [1] identify *Unnecessary Use of Multi-language Programming* as a design antipattern: introducing a second language (or, here, a second runtime tool) where the task is achievable in one adds complexity without benefit. Hao and Glassman [4] draw parallels between code-switching in polyglot programming and bilingualism — switching between bash and Bun within the same pipeline incurs cognitive overhead analogous to language interference.

The fix: replace `curl` with `fetch()` everywhere. One client, one error model.

### Trouble 3: Retry loop on API call

`scan-enrich` wrapped the arxiv API call in a `retry(3, 1000)` loop. First attempt returned HTTP 503. Second returned 503. Third succeeded — returned empty results for a valid ID. The retry obscured the transient failure pattern and produced empty metadata rows in DB. No log indicated the retry happened. The 503 was a permanent redirect issue — retry made it worse.

Di Marco and Trubiani [5] formalize performance antipattern detection at runtime — retry loops that mask persistent failures are a recognized antipattern. The Azure Architecture Center [6] documents *Retry Storm*: retrying endlessly when a service is unavailable wastes resources and obscures root cause.

The fix: remove retry. One attempt. On failure, `die()` prints the exact API response and exits.

### Trouble 4: Shell pipe `|` between tools

The pipeline ran `bun run scan-list | bun run scan-enrich | bun run scan-load`. Shell pipes connect stdout of one process to stdin of the next. `scan-enrich` crashed silently on a malformed input line — pipe broke, error propagation failed. `scan-load` received partial NDJSON, loaded what it got, exited cleanly. 40% of papers went missing — zero error indication.

Prakash et al. [7] identify fundamental challenges in analyzing N-language polyglot programs — pipe-based communication between runtimes is a key complexity point. Houdaille et al. [8] propose PolyDebug for debugging across runtime boundaries; the pipe breakage scenario is a direct case of cross-runtime debugging failure.

The fix: `scan-index.ts` orchestrates all three stages in one Bun process. Stage calls are TS function calls — errors propagate. No pipe, no partial data.

### Trouble 5: `grep`/`cat` in verification scripts

A verification script used `grep -c "die("` to count crash points and `cat *.ts | wc -l` for module size. The script assumed a shell environment with GNU grep and relative paths from the tools directory. When the subproject moved to a deeper path, the script broke silently — wrong cwd. A `bun -e` script resolved paths relative to the module — shell cwd independent.

Niephaus et al. [9] discuss the need for consistent development tooling across languages — shell-dependent scripts fail when the environment changes. The shell scripting antipatterns literature [10] documents path brittleness as a top antipattern: scripts that assume cwd, omit error handling, or depend on GNU-specific flags.

The fix: `bun -e "const { readDir } = await import('fs/promises')"`. Bun runtime, path-correct, no shell dependency.

## Key insight

The five troubles share a single root cause: **two runtimes in one subproject**. Bash and Bun mix silently — pipes break, `node_modules` drift, `curl` diverges from `fetch()`, retry swallows failures, path resolution bakes in cwd assumptions. The academic literature confirms each antipattern: Abidi et al. [1] catalog unnecessary multi-language use as a design antipattern; Neitsch et al. [2] find build system antipatterns in multilanguage software; Kochhar et al. [11] empirically show that more languages in a project correlates with higher defect proneness.

`PRE.BUN.ONLY.RUNTIME` eliminates the entire class by declaring one runtime, one execution model, one failure mode. Each antipattern resolves to: Bun runtime replaces the bash equivalent, linear control flow replaces retry, `die()` replaces silent swallow.

## References

1. Abidi, Khomh, Guéhéneuc. "Anti-patterns for multi-language systems." EuroPLoP 2019. `stud/antipatterns-runtimes/MLsmells-2019-Abidi.pdf`
2. Neitsch, Wong, Godfrey. "Build system issues in multilanguage software." ICSME 2012. `stud/antipatterns-runtimes/Neitsch-2012-BuildSystemIssues-Multilang.pdf`
3. Jafari et al. "Dependency Smells in JavaScript Projects." CS 2020. `stud/antipatterns-runtimes/2010-14573.pdf`
4. Hao, Glassman. "Approaching polyglot programming: what can we learn from bilingualism studies?" PLATEAU 2019. `stud/antipatterns-runtimes/Hao-Glassman-2019-Polyglot-Bilingualism.pdf`
5. Di Marco, Trubiani. "A model-driven approach to broaden the detection of software performance antipatterns at runtime." 2014. `stud/antipatterns-runtimes/1404-0851.pdf`
6. "Retry pattern." Azure Architecture Center, Microsoft.
7. Prakash et al. "Towards Analyzing N-language Polyglot Programs." 2026. `stud/antipatterns-runtimes/2602-00303.pdf`
8. Houdaille et al. "PolyDebug: A Framework for Polyglot Debugging." 2025. `stud/antipatterns-runtimes/2502-20537.pdf`
9. Niephaus et al. "Live Multi-language Development and Runtime Environments." 2018. `stud/antipatterns-runtimes/1803-10200.pdf`
10. "Shell Scripting: Patterns and AntiPatterns." dotlinux.net.
11. Kochhar et al. "A large scale study of multiple programming languages and code quality." SANER 2016.

## See also

- `PRE.BUN.ONLY.RUNTIME` — the maxim this antipattern collection motivates
- `REF.TOOL.NODE_MODULES.SHARED` — shared dep store eliminates per-project install
- `REF.LIB.DIRECTORY.LAYER` — lib import path convention prevents path brittleness
- `PROT.TOOL.DEFINITION` — Custom IPC tool shape replaces CLI registrations
- `stud/antipatterns-runtimes/` — 11 papers on multi-language antipatterns
