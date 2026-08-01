---
id: ILL.PLUGIN.FLOW
title: "Plugin Write Flow — Handler Delegation in ludoteca"
source: PROT.PLUGIN.WRITE
summary: "Concrete trace through three plugin write operations showing handler delegation, filesystem write, and DB sync."
illustration: "Three ludoteca plugins (add_reference, create_entity, sync) each delegate to a lib handler that normalizes, writes to the filesystem, and syncs to DB."
illustrates: [NEX.PLUGIN.LAYER]
tags: plugin,write,handler,walkthrough,ludoteca,flow
related: [NEX.LIB.STACK, PROT.TOOL.HOOKS]
---

## Rationale

Write layer separates side-effect-free reads from state-changing writes.

```
read layer:   MCP server (ludoteca-mcp) — 8 tools, side-effect-free
write layer:  OpenCode plugins (.opencode/plugins/) — 3 tools, filesystem + DB
fallback:     CLI tools (bun run .opencode/tools/) — manual operations
```

## Walkthrough

```
plugin tool            lib handler                 filesystem         DB
─────────────────      ──────────────────          ─────────         ──────
ludoteca_add_reference → reference-write.ts:        append seed →    INSERT OR REPLACE
                         addReference(type, fields)

ludoteca_create_entity → entity-write.ts:           write .md →      syncType()
                         createEntity(type, id, fields)

ludoteca_sync          → entity-sync.ts:            read .md files → syncType()
                         syncEntities({all: true})
```

## Key insight

Handler delegation separates write orchestration from I/O. Plugin tools never touch filesystem or DB directly. Each lib handler owns its complete write lifecycle: normalize → serialize → write → sync → return confirmation.

## See also

- `NEX.PLUGIN.LAYER` — the pattern this illustrates
- `NEX.LIB.STACK` — write handler stack definition
- `PROT.TOOL.HOOKS` — plugin lifecycle hooks
- `ILL.LIB.HANDLER.STACK` — read handler orchestration (complementary)
