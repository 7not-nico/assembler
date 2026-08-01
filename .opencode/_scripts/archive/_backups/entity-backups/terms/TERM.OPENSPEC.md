**OpenSpec** — an AI-native tool for generating, managing, and validating **API specifications** (OpenAPI, AsyncAPI, and GraphQL schemas). Developed by **Fission AI**, it exposes its workflow through a CLI and an **MCP server** that provides AI assistants with tools for spec generation (`openspec_generate`), validation (`openspec_validate`), change proposal management (`create_proposal`, `openspec_list_changes`), review and approval workflows (`openspec_request_approval`, `openspec_approve_change`), and task tracking. OpenSpec follows a **spec-driven development** paradigm in which specification documents are treated as the authoritative source of truth, with changes managed through a structured proposal, review, and approval lifecycle. The MCP server is installable via `npm install @fission-ai/openspec` and integrates with Cursor IDE, Claude Desktop, and other MCP-compatible assistants.


---
reference:
---
