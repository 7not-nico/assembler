# ch05-tasks.md

**Source:** https://mise.jdx.dev/tasks/, /tasks/task-configuration, /tasks/toml-tasks (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Task model

Tasks defined in `[tasks]` of mise.toml or standalone shell scripts. Run with `mise run {task}` (or `mise {task}` if no command conflict). Tasks include full mise environment — tools + env vars.

```toml
[tasks.build]
description = "Build the CLI"
run = "cargo build"
```

Favorites: parallel dependency building (default, no config); last-modified up-to-date skip (minimal config); `mise watch` auto-rebuild (no config).

## Task env vars

`MISE_ORIGINAL_CWD` (cwd where run), `MISE_CONFIG_ROOT` (dir containing defining mise.toml), `MISE_MONOREPO_ROOT` (monorepo only), `MISE_TASK_NAME`, `MISE_TASK_DIR` (script dir), `MISE_TASK_FILE` (script path).

## Properties

```
| Property | Type | Purpose |
|----------|------|---------|
| `run` | string / array / script | required; series execution, stops on first failure; multiline scripts; mix scripts + task refs `{ task, args?, env? }` |
| `depends` | list | before; args/env passable; shared deps run once; parallel up to --jobs; optional deps; `{{usage.*}}` arg forwarding |
| `depends_post` | list | after task + deps (e.g. postlint); same syntax as depends |
| `wait_for` | list | waits for already-scheduled tasks; doesn't add them; `optional = true` for unmatched |
| `tools` | map | per-task tools (different version); not passed to deps |
| `confirm` | string | guards only own run; deps run before prompt |
| `raw_args` | — | bypass mise usage parser; `mise run task -- --help` |
| `sources` | list | input files; with outputs → skip when outputs newer |
| `outputs` | list / `{ auto = true }` | output files; `!` excludes, `\!` escapes literal bang |
| `cache` | map (experimental) | key: sources, def, args, env, cache.env, command_inputs, tool versions, dep artifacts, OS/arch |
| `output` | string | style: prefix/interleave/keep-order/replacing/timed/quiet/silent |
| `usage` | string | CLI arg spec (TOML tasks only); `${usage_file?}` in scripts |
```

## Dependencies detail

```toml
[tasks.deploy]
depends = [
  { task = "build", args = ["--release"], env = { RUSTFLAGS = "-C opt-level=3" } },
]
run = "./deploy.sh"
```
- Optional: `{ task = "//...:test", optional = true }`
- Forward args: parent + child both define `usage`; `depends = [{ task = "build", args = ["{{usage.app}}"] }]`

## Sources/outputs caching

```toml
[tasks.build]
run = "cargo build"
sources = ["Cargo.toml", "src/**/*.rs"]
outputs = ["target/debug/mycli"]
```
Skip when oldest output newer than newest source. Exclusions: `"!src/**/*.test.ts"`; escape literal: `"\\!important.txt"`.

**Dependency invalidation** — dep re-runs (sources changed) → dependent re-runs even if its own sources unchanged. Deps without sources (always run) don't trigger this.

## Experimental task_config

- `task_config.cache` — scoped default for eligible tasks (sources + explicit outputs or `outputs = []`)
- `task_config.input_groups` — reusable `@group:` sources; groups reference groups
- `task_config.global_inputs` — source patterns for every task in scope
- `task_config.includes` — remote git includes: `git::<proto>://<url>//<path>?ref=<ref>` (protocol, url, path required; ref optional)

## Usage field (replaces Tera)

```toml
[tasks.test]
usage = 'arg "<file>" help="The file to test" default="src/main.rs"'
run = 'cargo test ${usage_file?}'
```

Flags with env fallback:
```toml
usage = 'flag "-p --profile <profile>" env="BUILD_PROFILE" help="Build profile" default="dev"'
```
- Env vars satisfy required args; precedence: CLI > env > default
- **Tera template functions (arg/option/flag) in run scripts DEPRECATED — removed 2027.5.0; migrate to `usage`**

## Monorepo

`monorepo_root = true` in root mise.toml; target path syntax (`//project:task`); subdirectory tasks use parent tools; descendants implicitly trusted when root trusted; tasks load on demand.

## Output styles

- `prefix` — default when jobs > 1; line-prefixed by task name
- `interleave` — default when jobs == 1; as-it-comes
- Others: keep-order, replacing, timed, quiet, silent

## Grounding

- concept/task-runner.md, concept/task-dependencies.md, concept/task-caching.md, concept/task-arguments.md
- research/mise-tasks.md
- reference/site-citations.md — task env, depends, sources/outputs, Tera removal quotes
