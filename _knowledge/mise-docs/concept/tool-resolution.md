# tool-resolution.md

Tool resolution is the three-step flow mapping version specs to usable binaries.

1. Configuration discovery — walk directory tree for config files, merge hierarchically. 2. Tool resolution — resolve specs (node@latest, python@3) via registries + version lists. 3. Environment setup — configure PATH + env vars. Compatible with asdf `.tool-versions` and idiomatic version files (`.node-version`, `.ruby-version`, opt-in). Auto-install on `mise x`/`mise r`/command-not-found when missing.

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-dev-tools.md | "1. Configuration Discovery… 2. Tool Resolution… 3. Environment Setup" |
| research/mise-dev-tools.md | "It's also compatible with asdf .tool-versions files as well as idiomatic version files" |
| research/mise-dev-tools.md | auto-install mechanisms |

## Sub-concepts

- path-activation (step 3 outcome)

## Distilled into

- note/ch03-dev-tools.md

## Precedes

path-activation
