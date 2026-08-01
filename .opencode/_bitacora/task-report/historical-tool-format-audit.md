# Historical Tool Format Audit

Active tools that predate the `PROT.TOOL.DEFINITION` protocol and their compliance status.

## Pre-Protocol Tools (Missing crashOnError)

These tools were created before `crashOnError()` was required by PROT.TOOL.DEFINITION Rule 9. They export `default tool({...})` correctly and have no `console.log`, but lack error reporting to the LLM.

| Tool | Class | Created context | Missing |
|------|-------|----------------|---------|
| `audit-commands.ts` | RECG | Early tooling | `crashOnError()` |
| `audit-patterns.ts` | RECG | Early tooling | `crashOnError()` |
| `audit-rules.ts` | RECG | Early tooling | `crashOnError()` |
| `audit-skills.ts` | RECG | Early tooling | `crashOnError()` |
| `audit-terms.ts` | RECG | Early tooling | `crashOnError()` |
| `verify-deps.ts` | RECG | Dependency management | `crashOnError()` |

These 6 tools constitute the "historicals" — tools that were built before the protocol was established. They work correctly in practice but do not follow the current protocol.

## Recently Created Tools (Protocol Compliant)

| Tool | Class | Has crashOnError? | Notes |
|------|-------|------------------|-------|
| `arxiv-search.ts` | TRNS | ✅ | Recent addition |
| `read-projection.ts` | TRNS | ✅ | Recent addition |
| `read-selection.ts` | TRNS | ✅ | Recent addition |
| `read-validate.ts` | RECG | ✅ | Recent addition |
| `section-extract.ts` | TRNS | ✅ | Recent addition |
| `mcp-compare.ts` | TRNS | ✅ | Recent addition |
| `mcp-features.ts` | TRNS | ✅ | Recent addition |
| `mcp-log-search.ts` | GENR | ✅ | Recent addition |
| `mcp-verify.ts` | SGNL | ✅ | Recent addition |

## Disabled Tools (Format Violations)

| Tool | Violations | Status |
|------|-----------|--------|
| `bench-vectors.ts` | Shebang, console.log, crashOnError missing, process.exit | Disabled |
| `reindex-vectors.ts` | Shebang, console.log, crashOnError missing, process.exit | Disabled |
| `search-vectors.ts` | Shebang, console.log, crashOnError missing, process.exit | Disabled |
| `similar-vectors.ts` | Shebang, console.log, crashOnError missing, process.exit | Disabled |
| `mcp-patlib-vector/` | None (MCP servers exempt) | Disabled (other reasons) |

## Migration Priority

| Priority | Tool | Effort | Impact |
|----------|------|--------|--------|
| 1 | 6 audit tools + verify-deps | ~1 min each (add import + call) | Closes historical gap |
| 2 | Reindex-vectors.ts → plugin | ~5 min | Restores reindex capability |
| 3 | Similar-vectors.ts → plugin | ~5 min | Restores similar search |
| 4 | Search-vectors.ts → plugin | ~10 min | Restores semantic search |
| 5 | Bench-vectors.ts → plugin | ~5 min | Restores diagnostics |
