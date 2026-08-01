**Model Context Protocol (MCP)** — an open protocol by Anthropic that standardizes how LLM applications connect to external data sources, tools, and workflows. Uses JSON-RPC 2.0 with a client-server architecture (Host → Client → Server). Core primitives: Resources, Prompts, Tools (server-side) and Sampling, Roots, Elicitation (client-side). Two standard transports: stdio and Streamable HTTP.

---
id: TERM.MCP
title: Model Context Protocol (MCP)
source: anthropic
tags: [protocol, llm, ai, tooling, json-rpc, integration, api, architecture]
terms: [TERM.OPENCODE.CUSTOM.TOOLS, TERM.OPENCODE.COMMANDS]
patterns: []
related: []
reference:
  - title: MCP Specification
    url: https://modelcontextprotocol.io/specification/2025-11-25
  - title: MCP Introduction
    url: https://modelcontextprotocol.io/docs/getting-started/intro
  - title: Launch Announcement
    url: https://anthropic.com/news/model-context-protocol
  - title: MCP GitHub Organization
    url: https://github.com/modelcontextprotocol
  - title: MCP Architecture
    url: https://modelcontextprotocol.io/docs/learn/architecture
---