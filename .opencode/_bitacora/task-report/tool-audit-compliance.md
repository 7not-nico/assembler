# Tool Audit Compliance

All active `.opencode/tools/` files checked against `audit-tool` skill rules (2026-07-23).

## Format Compliance

| Rule | Active | Disabled | Violations |
|------|--------|----------|------------|
| `export default tool({...})` | 17/17 | 0/5 | 5 disabled (shebang) |
| `@toolclass` at line 1 | 17/17 | 5/5 | 0 |
| imports from `_lib/` only | 17/17 | 5/5 | 0 |
| `crashOnError()` in execute | 17/17 | N/A | 0 |
| No console.log in execute | 17/17 | 0/5 | 5 disabled (uses `console.log`) |

## Tool Class Distribution

| Class | Active | Disabled | Meaning |
|-------|--------|----------|---------|
| TRNS (Transducer) | 9 | 4 | Read + write |
| RECG (Recognizer) | 6 | 1 | Read-only audit |
| GENR (Generator) | 1 | 0 | Generates output |
| SGNL (Signaler) | 1 | 0 | Side-effect signal |

## All Active Tools

| Tool | Class | Format | `_lib/` only | console.log |
|------|-------|--------|-------------|-------------|
| `arxiv-search.ts` | TRNS | plugin | ✅ | ❌ |
| `audit-commands.ts` | RECG | plugin | ✅ | ❌ |
| `audit-patterns.ts` | RECG | plugin | ✅ | ❌ |
| `audit-persons.ts` | TRNS | plugin | ✅ | ❌ |
| `audit-rules.ts` | RECG | plugin | ✅ | ❌ |
| `audit-skills.ts` | RECG | plugin | ✅ | ❌ |
| `audit-terms.ts` | RECG | plugin | ✅ | ❌ |
| `mcp-compare.ts` | TRNS | plugin | ✅ | ❌ |
| `mcp-features.ts` | TRNS | plugin | ✅ | ❌ |
| `mcp-log-search.ts` | GENR | plugin | ✅ | ❌ |
| `mcp-verify.ts` | SGNL | plugin | ✅ | ❌ |
| `read-projection.ts` | TRNS | plugin | ✅ | ❌ |
| `read-selection.ts` | TRNS | plugin | ✅ | ❌ |
| `read-validate.ts` | RECG | plugin | ✅ | ❌ |
| `section-extract.ts` | TRNS | plugin | ✅ | ❌ |
| `verify-deps.ts` | RECG | plugin | ✅ | ❌ |
| `write-sync.ts` | TRNS | plugin | ✅ | ❌ |

## Disabled Tools (Violations)

| Tool | Format | Import violation | console.log |
|------|--------|-----------------|-------------|
| `bench-vectors.ts` | shebang ❌ | ✅ (was fixed) | ✅ (violation) |
| `reindex-vectors.ts` | shebang ❌ | ✅ (was fixed) | ✅ (violation) |
| `search-vectors.ts` | shebang ❌ | ✅ | ✅ (violation) |
| `similar-vectors.ts` | shebang ❌ | ✅ | ✅ (violation) |
| `mcp-patlib-vector/` | MCP server (MCP servers exempt) | ✅ | N/A |

All disabled tools format violations would be resolved by converting to `export default tool({...})` and returning strings instead of `console.log`.
