# mise-configuration.md

**Source:** https://mise.jdx.dev/configuration/ (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Extract (verbatim)

> "`mise.toml` is the config file for mise. They can be at any of the following file paths (in order of precedence, top overrides configuration of lower paths):"
> - `mise.local.toml` - used for local config, this should not be committed to source control
> - `mise.toml`
> - `mise/config.toml`
> - `.mise/config.toml`
> - `.config/mise.toml` - use this in order to group config files into a common directory
> - `.config/mise/config.toml`

> "This list doesn't include Configuration Environments which allow for environment-specific config files like `mise.development.toml`—set with `MISE_ENV=development`. Platform-specific environments like `mise.windows.toml` or `mise.macos-arm64.toml` can be enabled automatically with the auto_env setting."

> "Merges them in order with more specific (closer to your current directory) settings overriding broader ones. 4. Applies environment-specific configs like `mise.dev.toml` if `MISE_ENV` is set"

> "Tools ([tools]): Additive with overrides — Global: node@18, python@3.11; Project: node@20, go@1.21; Result: node@20, python@3.11, go@1.21"

> "Tasks ([tasks]): Global: [tasks.test] = 'npm test'; Project: [tasks.test] = 'yarn test'; Result: 'yarn test' (completely replaces global)"

> "This behavior ensures that shared configuration (mise.toml) is updated by default, while local overrides (mise.local.toml) and environment-specific configs remain untouched unless explicitly targeted. Example: `$ mise use node@22` # writes to mise.toml; `$ mise use --env local node@20` # writes to mise.local.toml; `$ mise set NODE_ENV=production` # writes to mise.toml"

> "mise can be configured in `~/.config/mise/config.toml`. It works like a local `mise.toml`, but applies to every directory."

> "MISE_GLOBAL_CONFIG_FILE — Default: `$MISE_CONFIG_DIR/config.toml` (Usually `~/.config/mise/config.toml`)… MISE_DEFAULT_CONFIG_FILENAME — Default: `mise.toml`… MISE_GLOBAL_CONFIG_ROOT — Default: `$HOME`… MISE_ENV_FILE — Set to a filename to read env from a dotenv file. e.g.: `MISE_ENV_FILE=.env`. This searches for and loads all matching files in the current directory and parent directories. Uses dotenvy under the hood… MISE_${TOOL}_VERSION — Set the version for a tool. For example, `MISE_NODE_VERSION=20` will use node@20.x regardless of what is set in `mise.toml`/`.tool-versions`."

> "You can find the JSON schema for `mise.toml` in schema/mise.json or at https://mise.en.dev/schema/mise.json… Note that for included tasks, there is another schema: https://mise.en.dev/schema/mise-task.json"

## Claims surfaced

| # | Claim | Concept |
|---|-------|---------|
| 1 | Config paths with precedence; local not committed | concepts/config-hierarchy.md |
| 2 | Section merge: tools/env additive, tasks replace | concepts/config-hierarchy.md |
| 3 | MISE_ENV selects env-specific configs | concepts/config-hierarchy.md |
| 4 | Write targets: shared vs local files | concepts/config-hierarchy.md |
| 5 | JSON schema for editors | concepts/config-hierarchy.md |

## Feeds

- concepts/config-hierarchy.md
- reference/site-citations.md
