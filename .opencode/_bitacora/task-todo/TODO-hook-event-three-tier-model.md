## TODO-hook-event-three-tier-model

Update `PROT.PLUGIN.VALIDATION`, `PROT.PLUGIN.DIRECTION`, `PROT.PLUGIN.CANDIDATE`, and `PROT.TOOL.HOOKS` to encode the three-tier event model.

### Finding

`file.edited` fires on **opencode editor manual saves only**, not on agent Write/Bash tool calls. This contradicts assumptions baked into four protocols. All four describe hooks as if they catch all file changes equally.

### Changes

- **PROT.PLUGIN.VALIDATION** — expand hook matrix to three rows:
  - `file.edited` → "manual editor save" → "validate after manual edit"
  - `tool.execute.after` → "any agent tool execution (Write, Bash, sync, validate)" → "validate after agent-driven change"
  - reference `fs.watch` as filesystem-level alternative outside plugin scope

- **PROT.PLUGIN.DIRECTION** — replace ambiguous "file-change hooks" with disambiguated three-tier language. §32 "Exclusive event feature" should note that `file.edited` is editor-save only, while agent-driven file changes use `tool.execute.after`.

- **PROT.PLUGIN.CANDIDATE** — rewrite criterion-3 exception rationale. "Two hooks on same event" is incorrect — `file.edited` and `tool.execute.after` serve different trigger sources. Redescribe as "complementary hooks for different trigger sources (editor saves + agent tools)".

- **PROT.TOOL.HOOKS** — add `file.edited` to the hooks list with scope note: "fires on opencode editor file saves, not on agent Write/Bash tool calls". Currently missing from the doc entirely.

### Priority

high — incorrect semantics could cause wrong plugin implementations

### Verification

After edits, each protocol explicitly states the trigger scope for every hook it references.
