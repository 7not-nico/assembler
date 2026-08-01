# mise-homepage.md

**Source:** https://mise.jdx.dev/ + docs.rs/crate/mise README (2026-07-31), 2026.7.0
**Method:** parallel-search web_search + web_fetch excerpts

## Extract (verbatim)

> "Your dev environment, prepped and ready — One tool that manages dev tools, env vars, and tasks per project."

> "mise en place /meez ahn plahs/ 1. the gathering and arrangement of ingredients and tools before cooking. 2. a polyglot tool that keeps your project tools, env, and tasks in one place."

> "It installs the tools your project needs, loads its env vars, and runs its tasks — all configured in a single `mise.toml` checked into your repo, so every machine gets the same setup."

> "$ mise use node@24 python@3.13 → mise node@24.18.0 ✓ installed … mise ./mise.toml tools: node@24.18.0, python@3.13.14"

> "$ mise --version → 2026.7.0 linux-x64"

> "The Pantry · 1000+ tools, one config file" (node, python, ruby, go, rust, java, deno, bun, terraform, kubectl, zig, swift, php, elixir, …and 1000+ more)

> "The Recipe — 01 Install mise 02 Add and install tools 03 Load env vars 04 Define tasks"

> "$ cat .env.local → DATABASE_URL=postgres://localhost/orders; $ mise env -s bash → export DATABASE_URL='postgres://localhost/orders'; $ mise run test → [test] $ pytest → 42 passed in 1.02s"

> README: "Like asdf (or nvm or pyenv but for any language) it manages dev tools like node, python, cmake, terraform, and hundreds more. Like direnv it manages environment variables for different project directories. Like make it manages tasks used to build and test projects."

> README: "Note that calling `which node` gives us a real path to node, not a shim."

> README: "Due to the volume of issue submissions mise received, using GitHub Issues became unsustainable for the project. Instead, mise uses GitHub Discussions."

## Claims surfaced

| # | Claim | Concept |
|---|-------|---------|
| 1 | One tool: dev tools + env vars + tasks in single mise.toml | concepts/polyglot-config.md |
| 2 | Real PATH, no shims — which node returns real binary | concepts/path-activation.md |
| 3 | 1000+ tool registry | concepts/tool-registry.md |
| 4 | asdf+direnv+make replacement | concepts/polyglot-config.md |

## Feeds

- concepts/polyglot-config.md, concepts/path-activation.md, concepts/tool-registry.md
- reference/site-citations.md
