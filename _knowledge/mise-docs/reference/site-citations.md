# site-citations.md

**Layer:** reference/ — citations from the site, verbatim.
**Source:** mise.jdx.dev pages (2026-07-31), 2026.7.0

## Configuration citations

### Config paths (https://mise.jdx.dev/configuration/)

> "`mise.toml` is the config file for mise. They can be at any of the following file paths (in order of precedence, top overrides configuration of lower paths):"
> - `mise.local.toml` - used for local config, this should not be committed to source control
> - `mise.toml`
> - `mise/config.toml`
> - `.mise/config.toml`
> - `.config/mise.toml` - use this in order to group config files into a common directory
> - `.config/mise/config.toml`

### Merge behavior

> "Tools ([tools]): Additive with overrides — Global: node@18, python@3.11; Project: node@20, go@1.21; Result: node@20, python@3.11, go@1.21"
> "Tasks ([tasks]): … Result: 'yarn test' (completely replaces global)"

### Write targets

> "`$ mise use node@22` # writes to mise.toml; `$ mise use --env local node@20` # writes to mise.local.toml; `$ mise set NODE_ENV=production` # writes to mise.toml"

### Env vars

> "MISE_GLOBAL_CONFIG_FILE — Default: `$MISE_CONFIG_DIR/config.toml` … MISE_DEFAULT_CONFIG_FILENAME — Default: `mise.toml` … MISE_GLOBAL_CONFIG_ROOT — Default: `$HOME` … MISE_ENV_FILE — … searches for and loads all matching files in the current directory and parent directories. Uses dotenvy under the hood … MISE_${TOOL}_VERSION — … `MISE_NODE_VERSION=20` will use node@20.x regardless of what is set in `mise.toml`/`.tool-versions`."

### Schema

> "You can find the JSON schema for `mise.toml` in schema/mise.json or at https://mise.en.dev/schema/mise.json … there is another schema: https://mise.en.dev/schema/mise-task.json"

## Dev tools citations (https://mise.jdx.dev/dev-tools/)

### Resolution flow

> "1. Configuration Discovery: mise walks up the directory tree looking for configuration files (mise.toml, .tool-versions, etc.) and merges them hierarchically. 2. Tool Resolution: mise resolves version specifications (like node@latest or python@3) to specific versions using registries and version lists. 3. Environment Setup: mise configures your PATH and environment variables to use the resolved tool versions"

### Activation

> "Automatic Activation: With `mise activate`, mise hooks into your shell prompt and automatically updates your environment when you change directories: `eval "$(mise activate zsh)"`"
> "On-Demand Execution: Use `mise exec` to run commands with mise's environment without permanent activation: `mise exec -- node my-script.js`"

### Zero overhead

> "It exits early if the directory wasn't changed or `mise.toml`/`.tool-versions` files haven't been modified. `mise` modifies `PATH` ahead of time so the runtimes are called directly. This means that calling a tool has zero overhead and commands like `which node` returns the real path to the binary."

### Commands

> "`mise use node@26` will install the latest version of node-26 and create/update the `mise.toml` config file in the local directory… `mise use -g node@26` … update the global config"
> "`mise install` will install but not activate tools—meaning it will download/build/compile the tool into `~/.local/share/mise/installs`"

### Auto-install

> "All mechanisms require the global auto_install setting to be enabled (all auto_install settings are enabled by default)."

## Environments citations (https://mise.jdx.dev/environments/)

### Semantics

> "To clear an env var, set it to `false`"
> "To set a fallback while preserving an existing non-empty value, use `default`"
> "Variables can be redacted from the output by setting `redact = true`"
> "You can mark environment variables as required by setting `required = true`"

### Directives

> "`env._.*` define special behavior for setting environment variables. (e.g.: reading env vars from a file)… we make use of this fact by creating a key named '_' which is a TOML table for the configuration of these directives."

> "WARNING: Top-level `env_file`, `dotenv`, and `env_path` are deprecated. Use `env._.file` and `env._.path` instead. These keys will be removed in mise 2027.4.0."

### Lazy eval

> "Environment variables typically are resolved before tools—that way you can configure tool installation subprocesses with environment variables. This does not apply to variables that configure mise itself, such as `MISE_DATA_DIR` or `MISE_INSTALLS_DIR`."

## Tasks citations (https://mise.jdx.dev/tasks/, /tasks/task-configuration, /tasks/toml-tasks)

### Task env

> "MISE_ORIGINAL_CWD: The original working directory from where the task was run. MISE_CONFIG_ROOT: The directory containing the `mise.toml` file where the task was defined… MISE_TASK_NAME: The name of the task being run. MISE_TASK_DIR: The directory containing the task script. MISE_TASK_FILE: The full path to the task script."

### Depends

> "depends: Tasks that must be run before this task. This is a list of task names or aliases. Arguments can be passed to the task, e.g.: `depends = ["build --release"]`. If multiple tasks have the same dependency, that dependency will only be run once. mise will run whatever it can in parallel (up to --jobs)."

> "depends_post: Like `depends` but these tasks run _after_ this task and its dependencies complete."
> "wait_for: … does not add matching tasks to the run; it only waits for them when they are already scheduled."

### Sources/outputs

> "mise will skip executing tasks where the modification time of the oldest output file is newer than the modification time of the newest source file."

### Usage + deprecation

> "More advanced usage specs can be added to the task's `usage` field. This only applies to toml-tasks."

> "Using Tera template functions (arg(), option(), flag()) in run scripts is **deprecated** and will be **removed in mise 2027.5.0**. Versions >= 2026.5.0 will show a deprecation warning… Please migrate to using the `usage` field instead."

## Claim mapping

```
| Note claim | Citation |
|------------|----------|
| ch01: one tool, three roles | homepage "One tool that manages dev tools, env vars, and tasks" |
| ch01: real PATH no shims | dev-tools "which node returns the real path" |
| ch02: config precedence | configuration "top overrides configuration of lower paths" |
| ch02: tasks merge replaces | configuration "completely replaces global" |
| ch03: resolution 3 steps | dev-tools "1. Configuration Discovery… 3. Environment Setup" |
| ch03: hook-env fast-exit | dev-tools "exits early if the directory wasn't changed" |
| ch04: env._ directives | environments "env._.* define special behavior" |
| ch04: deprecation 2027.4.0 | environments "removed in mise 2027.4.0" |
| ch05: MISE_* task env | tasks "MISE_ORIGINAL_CWD: The original working directory" |
| ch05: Tera removal | toml-tasks "removed in mise 2027.5.0" |
```
