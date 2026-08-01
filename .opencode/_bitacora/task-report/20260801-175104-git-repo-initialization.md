# Git Repo Initialization

Timestamp: 2026-08-01 175104

## What was done

Initialized the assembler root as a git repository and published it to GitHub, then curated the content through 24 commits.

1. **Repo created** — `git init` at `/home/eddyr/assembler`, remote `origin` → `https://github.com/7not-nico/assembler.git` (account `7not-nico`, verified via `gh`), visibility **public** (user decision).
2. **Branch renamed** — `master` → `main`; GitHub default branch updated; remote `master` deleted.
3. **Content committed in granular batches** (user confirmed each): root structure, entity system (605), rules (162), skills (227), commands (32), tools+lib (80), scripts toolchain (678), rustlib archive, bitacora+configs (257), then the aggregator architecture.
4. **Aggregator convention established** — `_{abstract-noun}/` domains: contents live in their own repos; the root repo tracks substrate `_bitacora/_templates/_impressions/_scripts` with contents + top-level placeholders. Codified in `AGGREGATORS.md` + `.gitignore`. `_sandbox/` added (renamed from `sandbox/`).
5. **Bloat incidents handled** — 3 rounds of build artifacts/node_modules leaked into commits (`_rustlib/target/` 388 files, playwright-core `node_modules` 227 files); each stripped via `git rm --cached` + ignore-pattern fixes (depth-agnostic `**/` patterns, precedence ordering).
6. **Untracked leak closed** — `!/_*/` reopened aggregator roots; fixed with `/_*/*` + depth-1 substrate un-ignores; noise 57 → 0; `.webm`/HTML experiments ignored.
7. **Pruned** — `git reflog expire --expire=now --all && git gc --prune=now`: pack 2.94 GiB → **15.97 MiB** (reclaimed unreachable rustlib/node_modules objects).

## Decisions

- Repo **public** (user decision 2026-08-01)
- Branch **main** (renamed from master)
- Domain contents → own repos; root tracks only substrate + placeholders
- Build artifacts, node_modules, multimedia, DBs, `.backups/` stay out (ignore rules with precedence after un-ignores)
- Incremental granular commits with per-batch user confirmation
- History rewrites avoided for pushed commits (strip via follow-up commits; the rustlib commit was rewritten while unpushed)

## Open edges

- Session logs accrue between commits (stdout logs of each git run committed in sweeps)
- `git gc` runs periodically as unreachable objects accumulate
- Crossref stale-ID backlog deferred (separate thread: `resolve-remaining-stale-protocol-ids`)

## Todo state

- This session's git work — completed (24 commits on `main`)
- `task-todo/2026-08-01--resolve-remaining-stale-protocol-ids.md` — deferred (in progress)
- `task-todo/2026-08-01--continue-session-queue.md` — completed

## Logs

- `task-stdout/20260801-175048-git-gc-prune.log` — pack 2.94GiB → 15.97MiB
- `task-stdout/20260801-174906-git-ann-sources.log`, `...-174812-git-ignore-root-fix.log`, `...-174205-git-skills-logs.log` — session git runs
- Full series: `git-*` logs under `task-stdout/` (all committed)
