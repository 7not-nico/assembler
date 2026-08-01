# env-directives.md

Env directives are the `env._` special behaviors for loading environment variables.

`env._.file` — dotenv/json/yaml/toml loading (options: redact, tools, expand); `env._.path` — PATH additions (absolute, `{{config_root}}`-relative, plain relative); `env._.source` — shell sourcing. Semantics: `false` clears, `{default = "x"}` preserves existing, `redact` hides, `required` enforces definition. Lazy eval: env resolves before tools. Top-level `env_file`/`dotenv`/`env_path` deprecated → removed 2027.4.0.

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-environments.md | "env._.* define special behavior for setting environment variables" |
| research/mise-environments.md | deprecation warning 2027.4.0 |
| research/mise-environments.md | false clears, default preserves, redact, required |

## Sub-concepts

- config-hierarchy (env merge additive)

## Distilled into

- note/ch04-environments.md

## Precedes

(leaf — no inner entities)
