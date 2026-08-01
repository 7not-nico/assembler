# mise-environments.md

**Source:** https://mise.jdx.dev/environments/ (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Extract (verbatim)

> "Load the right _environment variables_ automatically for each project directory."

> "To clear an env var, set it to `false`… To set a fallback while preserving an existing non-empty value, use `default`: `NODE_ENV = { default = "development" }`. This keeps `NODE_ENV` if it was already set before mise ran or by an earlier config file. If it is unset or empty, mise sets it to `"development"`. Defaults can be strings or integers."

> "Additionally, the `mise env [--json] [--dotenv]` command can be used to export the environment variables in various formats (including `PATH` and environment variables set by tools or plugins)."

> "Lazy eval: Environment variables typically are resolved before tools—that way you can configure tool installation subprocesses with environment variables. This does not apply to variables that configure mise itself, such as `MISE_DATA_DIR` or `MISE_INSTALLS_DIR`."

> "Variables can be redacted from the output by setting `redact = true`… You can also use the `redactions` array to mark multiple environment variables as sensitive."

> "You can mark environment variables as required by setting `required = true`. This ensures that the variable is defined either before mise runs or in a later config file (like `mise.local.toml`)."

> "`env._.*` define special behavior for setting environment variables. (e.g.: reading env vars from a file). Since nested environment variables do not make sense, we make use of this fact by creating a key named '_' which is a TOML table for the configuration of these directives."

> "In `mise.toml`: `env._.file` can be used to specify a dotenv file to load. WARNING: Top-level `env_file`, `dotenv`, and `env_path` are deprecated. Use `env._.file` and `env._.path` instead. These keys will be removed in mise 2027.4.0."

> "The `env._.file` directive supports: A single file as a string or an object; Multiple files as an array of strings and objects; Using relative or absolute paths; Using `dotenv`, `json`, `yaml`, or `toml` file formats; The `redact`, `tools`, and `expand` options."

> "env._.path: adds an absolute path `"~/.local/share/bin"`; adds a path relative to the project root (config_root) `"{{config_root}}/node_modules/.bin"`; adds a relative path (equivalent to `"{{config_root}}/tools/bin"`) `"tools/bin"`."

> "The `env._.source` directive supports: A single source as a string or an object; Multiple sources as an array of strings and objects; Using relative or absolute paths; The `redact` and `tools` options."

## Claims surfaced

| # | Claim | Concept |
|---|-------|---------|
| 1 | false clears, default preserves, redact, required | concepts/env-directives.md |
| 2 | env._.file/.path/.source special directives | concepts/env-directives.md |
| 3 | Lazy eval: env before tools | concepts/env-directives.md |
| 4 | Deprecation: top-level env_file → env._.file by 2027.4.0 | concepts/env-directives.md |

## Feeds

- concepts/env-directives.md
- reference/site-citations.md
