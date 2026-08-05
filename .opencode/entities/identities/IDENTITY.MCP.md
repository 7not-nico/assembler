**MCP** — an agent-facing tool transport layer. TypeScript MCP servers communicating via JSON-RPC 2.0 over stdio using `StdioServerTransport`. Protocol is stateless per the 2026-07-28 spec revision — no initialize handshake, per-request protocol version and client capabilities in `_meta`. Servers implement `server/discover` to advertise versions, capabilities, and identity. Read-only by default per `PAT.MCP.READONLY`. Discovered via `opencode.json` config entry. Configured per-project.

---
id: IDENTITY.MCP
title: MCP — Agent-Facing Tool Transport Layer
source: PROT.MCP.TRANSPORT
group: architectonic
ring: R2
naming: MCP.{NAME}
tags: mcp,tool,identity,transport,server,convention,architecture,metadata
related: [IDENTITY.CLI, IDENTITY.IPC, IDENTITY.PLUGIN, IDENTITY.SCRIPT, NEX.TOOL.LAYER.CHOICE]
reference:
  - title: PROT.MCP.TRANSPORT — stdio transport contract
    url: https://opencode.ai/docs
  - title: PROT.TOOL.DISCOVERY — MCP auto-discovery
    url: https://opencode.ai/docs
  - title: MCP specification 2026-07-28 — stateless protocol revision
    url: https://modelcontextprotocol.io/specification/2026-07-28
  - title: SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY — groups, layers
    url: https://opencode.ai/docs
---
