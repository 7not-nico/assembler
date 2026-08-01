## TODO-nexus-layer-choice-event-model

Update `NEX.TOOL.LAYER.CHOICE` and `ILL.TOOL.LAYER.CHOICE.DECIDE` to reflect the three-tier event model.

### Finding

`NEX.TOOL.LAYER.CHOICE` §24: *"Event-driven (`file.edited` hook) → Plugin (only layer with event support)"*. This conflates "plugin hooks" with "all event support". MCP servers with `fs.watch` also provide event-driven file monitoring — kernel-level, cross-source.

`ILL.TOOL.LAYER.CHOICE.DECIDE` Scenario C table: *"MCP — No — MCP servers lack file edit hooks"*. True for opencode's `file.edited` hook system, but MCP has `fs.watch` at the Node/Bun API level.

### Changes

- **NEX.TOOL.LAYER.CHOICE** — replace "only layer with event support" with three-tier matrix:
  - Plugin `file.edited` → editor saves
  - Plugin `tool.execute.after` → agent tool execution
  - MCP `fs.watch` → any-source filesystem changes
  - CLI → no event support (polling only)

- **ILL.TOOL.LAYER.CHOICE.DECIDE** — add "fs.watch / any-source" as a fourth consideration in Scenario C (or a new Scenario D). The current "Plugin is only viable option" conclusion only holds for opencode-internal editor events.

### Priority

medium — doesn't cause incorrect behavior, but creates blind spot in layer-choice reasoning

### Verification

Decision table in the nexus correctly maps all three event sources to their viable layers.
