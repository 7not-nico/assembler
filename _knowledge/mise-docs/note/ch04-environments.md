# ch04-environments.md

**Source:** https://mise.jdx.dev/environments/ (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Basic env vars

```toml
[env]
NODE_ENV = 'production'
```

- **Clear**: `NODE_ENV = false` — unset previously set var
- **Fallback**: `NODE_ENV = { default = "development" }` — preserves existing non-empty value
- CLI: `mise set MY_VAR=123`; export: `mise env [--json] [--dotenv]`

Available with `mise x|exec` and `mise r|run`.

## Task env

```toml
[tasks.print]
run = "echo $MY_VAR"
env = { _.file = '/path/to/file.env', "MY_VAR" = "my variable" }
```

## Lazy eval

Env vars resolve before tools — configures tool install subprocesses. Exception: mise's own vars (`MISE_DATA_DIR`, `MISE_INSTALLS_DIR`). `tools = true` defers resolution until after tools:

```toml
[env]
MY_VAR = { value = "tools path: {{env.PATH}}", tools = true }
NODE_VERSION = { value = "{{ tools.node.version }}", tools = true }
```

## Redactions

```toml
[env]
SECRET = { value = "my_secret", redact = true }
_.file = { path = ".env.json", redact = true }
```
`redactions` array marks multiple sensitive vars.

## Required variables

```toml
[env]
DATABASE_URL = { required = true }
```
Satisfied by earlier env or later config file (e.g. `mise.local.toml`). Optional help text. Use cases: API keys, DB connections, feature flags.

## `env._` directives

`_` is a reserved TOML key for special env behavior:

```
| Directive | Purpose | Options |
|-----------|---------|---------|
| `env._.file` | dotenv/json/yaml/toml loading | redact, tools, expand |
| `env._.path` | PATH additions | absolute, `{{config_root}}`-relative, plain relative |
| `env._.source` | shell sourcing | redact, tools |
```

```toml
[env]
_.file = '.env'
_.path = ["{{config_root}}/node_modules/.bin", "tools/bin"]
_.source = { path = "my/env.sh", tools = true }
```

- Paths resolve relative to declaring config file
- **Deprecated**: top-level `env_file`, `dotenv`, `env_path` — removed 2027.4.0
- dotenv parsing via dotenvy crate; JSON/YAML/TOML separate parsers

## Grounding

- concept/env-directives.md
- research/mise-environments.md
- reference/site-citations.md — semantics + directives + deprecation quotes
