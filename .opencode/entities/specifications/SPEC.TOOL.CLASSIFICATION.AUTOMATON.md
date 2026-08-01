**Tool Classification** — every tool and plugin has an I/O automaton model. Tools declare via `// @toolclass <CODE>`; plugins declare via `// @pluginclass <CODE>`. Both at line 1.

## Classes

- **RECG (acceptor)** — read-only. Inspects data, decides membership, returns result. No writes to persistent state.
- **TRNS (transducer)** — separate input and output tapes. Reads source data and writes transformed data. Input and output refer to different data domains.
- **GENR (generator)** — write-only. Produces output without reading existing state.
- **SGNL (synchronizer)** — read-write coordination. Reads state and coordinates writes across multiple domains.

## Rules

- Every tool and plugin belongs to exactly one of the four classes.
- Root-level MCP tools use RECG (read-only).
- Subproject MCP tools may use RECG or TRNS.
- Plugins use GENR (write-only).
- Class declared via `// @toolclass <CODE>` (tools) or `// @pluginclass <CODE>` (plugins) at line 1.

## Applicability

All tools in `.opencode/tools/` and all plugins in `.opencode/plugins/`.

---
id: SPEC.TOOL.CLASSIFICATION.AUTOMATON
title: Tool Classification — Automata Theory I/O Model
source: assembler
summary: "Every tool and plugin has an I/O automaton model classified as RECG (read-only), TRNS (separate tapes), GENR (write-only), or SGNL (read-write). Declared via // @toolclass or // @pluginclass at line 1."
specifies: RECG/TRNS/GENR/SGNL tool I/O automaton classification
tags: [tooling, architecture, automata, classification, convention, specification]
status: active
---
