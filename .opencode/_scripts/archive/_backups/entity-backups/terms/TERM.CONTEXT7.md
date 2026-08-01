**Context7** — an **MCP server** by **Upstash** that provides AI assistants with up-to-date, version-specific documentation and code examples for programming libraries and frameworks. It exposes two tools: `resolve-library-id` (resolves a package or product name to a Context7-compatible library ID in the format `/org/project[/version]`) and `query-docs` (retrieves and ranks relevant documentation and code snippets for a given library ID and query). Context7 integrates documentation from **OpenAPI specs**, official docs, and source repositories, and serves as a canonical example of the **retrieval-augmented generation (RAG)** pattern applied to developer tooling. Configuration uses the server URL `https://mcp.context7.com/mcp` with an API key passed via the `CONTEXT7_API_KEY` header.


---
reference:
---
