# Tool Group Compliance — RECG / TRNS / GENR / SGNL

Compliance of each tool group (PROT.TOOL.AUTOMATON) against audit rules.

## RECG — Read-Only (Acceptor/Recognizer)

RECG tools inspect data and return results. No writes to persistent state.

| Tool | export default tool | crashOnError() | console.log | Imports from _lib/ |
|------|-------------------|----------------|-------------|-------------------|
| `audit-commands.ts` | ✅ | ❌ | ✅ none | ✅ |
| `audit-patterns.ts` | ✅ | ❌ | ✅ none | ✅ |
| `audit-rules.ts` | ✅ | ❌ | ✅ none | ✅ |
| `audit-skills.ts` | ✅ | ❌ | ✅ none | ✅ |
| `audit-terms.ts` | ✅ | ❌ | ✅ none | ✅ |
| `read-validate.ts` | ✅ | ✅ | ✅ none | ✅ |
| `verify-deps.ts` | ✅ | ❌ | ✅ none | ✅ |

**Violations**: 6/7 RECG tools are missing `crashOnError()` — violates PROT.TOOL.DEFINITION Rule 9.

## TRNS — Read-Write (Transducer)

TRNS tools read source data and write transformed data to a different domain.

| Tool | export default tool | crashOnError() | console.log | Imports from _lib/ |
|------|-------------------|----------------|-------------|-------------------|
| `arxiv-search.ts` | ✅ | ✅ | ✅ none | ✅ |
| `audit-persons.ts` | ✅ | ✅ | ✅ none | ✅ |
| `mcp-compare.ts` | ✅ | ✅ | ✅ none | ✅ |
| `mcp-features.ts` | ✅ | ✅ | ✅ none | ✅ |
| `read-projection.ts` | ✅ | ✅ | ✅ none | ✅ |
| `read-selection.ts` | ✅ | ✅ | ✅ none | ✅ |
| `section-extract.ts` | ✅ | ✅ | ✅ none | ✅ |
| `write-sync.ts` | ✅ | ✅ | ✅ none | ✅ |

**Violations**: None — all 8 TRNS tools are compliant.

## GENR — Write-Only (Generator)

GENR tools produce output from internal state or parameters without reading persistent state.

| Tool | export default tool | crashOnError() | console.log | Imports from _lib/ |
|------|-------------------|----------------|-------------|-------------------|
| `mcp-log-search.ts` | ✅ | ✅ | ✅ none | ✅ |

**Violations**: None — 1/1 GENR tool is compliant.

## SGNL — Read-Write Shared State (Signaler)

SGNL tools coordinate by inspecting and updating a common store.

| Tool | export default tool | crashOnError() | console.log | Imports from _lib/ |
|------|-------------------|----------------|-------------|-------------------|
| `mcp-verify.ts` | ✅ | ✅ | ✅ none | ✅ |

**Violations**: None — 1/1 SGNL tool is compliant.

## Summary by Group

| Group | Total | Compliant | Violations | Compliance rate |
|-------|-------|-----------|------------|-----------------|
| RECG | 7 | 1 | 6 (missing crashOnError) | 14% |
| TRNS | 8 | 8 | 0 | 100% |
| GENR | 1 | 1 | 0 | 100% |
| SGNL | 1 | 1 | 0 | 100% |

## Key Finding

All violations are in the RECG group — specifically the `audit-*` tools and `verify-deps`. These are the oldest tools in the project. They were created before `crashOnError()` was added to the protocol.

The RECG group is the only group that violates rules because these tools predate the `crashOnError()` requirement. All TRNS, GENR, and SGNL tools follow the rules.

## Fix Required

Add `crashOnError()` to these 6 RECG tools:
1. `audit-commands.ts`
2. `audit-patterns.ts`
3. `audit-rules.ts`
4. `audit-skills.ts`
5. `audit-terms.ts`
6. `verify-deps.ts`

Each needs:
```typescript
import { crashOnError } from "../_lib/errors"
// then in execute():
crashOnError()
```
