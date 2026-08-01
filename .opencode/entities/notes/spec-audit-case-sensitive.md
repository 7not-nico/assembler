# spec-audit — case_sensitive column needed

`spec-audit.ts` hardcodes `"gi"` flag on all regex checks. DB rules store patterns like `"NOT"` which with `gi` match English "not" in natural prose — false positives.

Current workaround: lookbehind `(?<![a-z])NOT(?![a-z])` in the seed pattern, but with `gi` the `[a-z]` ranges also match uppercase. Partial fix only.

## Required changes

| File | Change |
|------|--------|
| `llm-spec.sql` | Add `case_sensitive INTEGER NOT NULL DEFAULT 0` column to `llm_spec_rules` |
| `spec-types.ts` | Add `caseSensitive: boolean` to `Rule` interface |
| `spec-rules.ts` | Map column to `Rule.caseSensitive` in `loadRules()` |
| `spec-audit.ts` | Use `caseSensitive ? "g" : "gi"` in `new RegExp(p, flags)` at line 23 |

## Impact

- `CONJUNCTION_OPERATOR` — set `case_sensitive=1` → `\bAND\b` only matches all-caps operator, not prose "and"
- `NEGATION_OPERATOR` — set `case_sensitive=1` → `NOT` only matches uppercase operator, not prose "not"
- `DECLARATIVE_REGISTER` — set `case_sensitive=1` → `NEVER`, `DO NOT`, etc. only match uppercase forms
- All other rules keep `case_sensitive=0` (current behavior — case-insensitive is correct for their patterns)

## Not done yet

Deferred as scope decision during initial mcp-spec-audit creation. False positive noise is 4 warnings on the propose-mcp skill — acceptable for now.
