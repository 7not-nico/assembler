## TODO-seed-schema-plugin-hooks

Update `PROT.SCHEMA.FORMAT`, `REF.SCHEMA.PLUGIN.BOILERPLATE`, `ILL.SCHEMA.PLUGIN.BOILERPLATE`, and `REF.SCHEMA.SEED.MUTATION` to document the `file.edited` scope limitation for seed/schema plugins.

### Finding

All four entities assume `file.edited` catches "file save" generically. Three of them prescribe registering a `file.edited` hook as the auto-correction mechanism. None mention that agent Write/Bash tool edits to seed `.sql` files bypass `file.edited`.

### Changes

- **PROT.SCHEMA.FORMAT** §4 — add caveat: "`file.edited` fires on opencode editor saves only. Agent Write/Bash tool edits to seed files require `tool.execute.after` registration for auto-correction."

- **REF.SCHEMA.PLUGIN.BOILERPLATE** §4 (Auto-correction hook) — add same caveat with example registration of both hooks.

- **ILL.SCHEMA.PLUGIN.BOILERPLATE** — add commentary in the hook-registration step: "This hook catches manual editor saves only. For agent-driven seed edits, register a companion `tool.execute.after` handler."

- **REF.SCHEMA.SEED.MUTATION** — update the enforcement line: "Format conventions are enforced by file-edited hooks on save (manual editor) and tool.execute.after hooks on agent tool execution."

### Priority

medium — no immediate breakage, but schema/seed plugins built from these docs will miss agent-driven changes

### Verification

Each entity that prescribes `file.edited` registration now includes a scope note.
