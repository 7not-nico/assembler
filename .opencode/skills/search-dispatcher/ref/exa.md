# Exa

**Route** — search the web semantically and extract clean content: describe the ideal page, read full pages when excerpts fall short.

**Target** — load `use-exa` before Exa MCP work.

**Notes**

- Describe the ideal page in natural language — rich description beats keyword queries.
- Read the top results' excerpts first — they usually answer directly.
- Fetch a URL only when excerpts conflict or fall short — full-page extraction costs more.
- Pass multiple related URLs in one fetch — one call covers the batch.
- Use `maxCharacters` to bound fetch depth — default 3000.
