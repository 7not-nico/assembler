# mise-dev-tools.md

**Source:** https://mise.jdx.dev/dev-tools/ (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Extract (verbatim)

> "To know which tool version to use, mise will typically look for a `mise.toml` file in the current directory and its parents."

> "It's also compatible with asdf `.tool-versions` files as well as idiomatic version files like `.node-version` and `.ruby-version`."

> "Tool Resolution Flow: 1. Configuration Discovery: mise walks up the directory tree looking for configuration files (mise.toml, .tool-versions, etc.) and merges them hierarchically. 2. Tool Resolution: mise resolves version specifications (like node@latest or python@3) to specific versions using registries and version lists. 3. Environment Setup: mise configures your PATH and environment variables to use the resolved tool versions"

> "Automatic Activation: With `mise activate`, mise hooks into your shell prompt and automatically updates your environment when you change directories: `eval "$(mise activate zsh)"` # In your ~/.zshrc. On-Demand Execution: Use `mise exec` to run commands with mise's environment without permanent activation: `mise exec -- node my-script.js`"

> "mise modifies your PATH environment variable to prioritize the correct tool versions… After mise activation in a project with node@20: /home/user/.local/share/mise/installs/node/20.11.0/bin:/usr/local/bin:/usr/bin:/bin"

> "Configuration Hierarchy: ~/.config/mise/config.toml # Global defaults; ~/work/mise.toml # Work-specific tools; ~/work/project/mise.toml # Project-specific overrides; ~/work/project/.tool-versions # Legacy asdf compatibility"

> "After activating, every time your prompt displays it will call `mise hook-env` to fetch new environment variables. This should be very fast. It exits early if the directory wasn't changed or `mise.toml`/`.tool-versions` files haven't been modified. `mise` modifies `PATH` ahead of time so the runtimes are called directly. This means that calling a tool has zero overhead and commands like `which node` returns the real path to the binary."

> "`mise use node@26` will install the latest version of node-26 and create/update the `mise.toml` config file in the local directory… `mise use -g node@26` will do the same but update the global config (~/.config/mise/config.toml)"

> "`mise install` will install but not activate tools—meaning it will download/build/compile the tool into `~/.local/share/mise/installs` but you won't be able to use it without 'setting' the version in a `.mise-toml` or `.tool-versions` file."

> "All mechanisms require the global auto_install setting to be enabled (all auto_install settings are enabled by default). When you run a command like `mise x` or `mise r`, mise will automatically install any missing tool versions required to execute the command… If you type a command in your shell (e.g., node) and it is not found, mise can attempt to auto-install the missing tool version if it knows which tool provides that binary."

## Claims surfaced

| # | Claim | Concept |
|---|-------|---------|
| 1 | Tool resolution: discovery → resolve → env setup | concepts/tool-resolution.md |
| 2 | activate hooks shell; exec on-demand | concepts/path-activation.md |
| 3 | hook-env fast-exit; zero overhead real PATH | concepts/path-activation.md |
| 4 | Auto-install on exec/run/command-not-found | concepts/tool-resolution.md |
| 5 | Legacy compat: .tool-versions, .node-version | concepts/tool-resolution.md |

## Feeds

- concepts/tool-resolution.md, concepts/path-activation.md
- reference/site-citations.md
