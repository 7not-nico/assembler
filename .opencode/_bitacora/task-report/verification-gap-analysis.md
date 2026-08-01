# Verification Gap Analysis

Why the error was not caught during development, only at session start.

## The Gap

```
Development                    Session Start
─────────────────────────────────────────────────
Write tool → Run once →        opencode scans
Smoke test passes               tools/ and validates
                               ──────────────────
                               ❌ Format violation detected
                               ❌ User blocked
```

The tool was created, smoke-tested with `bun run tools/tool.ts`, worked correctly, and was committed. The validation failure only appeared when a **new opencode session** started in `assembler/`.

## Why the Gap Exists

| Check | Dev environment | Session start |
|-------|----------------|---------------|
| `bun build --no-bundle` | ✅ Passes | N/A |
| `bun run` with test args | ✅ Works | N/A |
| `export default tool({...})` | ❌ Not checked | ✅ Validated |
| `@toolclass` format | ❌ Not checked | ✅ Validated |
| `_lib/` import paths | ❌ Not checked | ✅ Validated |
| No `console.log` | ❌ Not checked | ✅ Validated |
| `crashOnError()` present | ❌ Not checked | ✅ Validated |
| Args have `.describe()` | ❌ Not checked | ✅ Validated |

**The gap**: `bun run` executes the file as a standalone script. It does not validate plugin format compliance. Only opencode's startup scan runs `audit-tool` rules.

## What We Mistook for Verification

| Step | What we thought | What was actually checked |
|------|----------------|--------------------------|
| `rg 'import.*from.*tools/'` | "No cross-tool imports" ✅ | Import paths only — not format |
| `bun build --no-bundle` | "Compiles fine" ✅ | TypeScript compilation only |
| `bun run --help` | "Help text works" ✅ | Runtime execution — no format validation |
| Smoke test results | "Output is correct" ✅ | Functional correctness only |

None of these checks validate the **plugin format** — the actual requirement that opencode enforces on startup.

## How to Close the Gap

### Option 1: Run audit-tool during development

After creating a new tool, run the audit checks manually:

```bash
# Check format
head -1 tools/new-tool.ts | grep -q 'export default tool'

# Check imports
rg 'from.*["\x27]' tools/new-tool.ts | grep -v '_lib' | grep -v '@opencode'

# Check no console.log
rg 'console\.(log|error)' tools/new-tool.ts
```

### Option 2: Create an audit tool

`tools/audit-tool-files.ts` that checks all tool files and returns a compliance report. Run it after any tool change and on session start.

### Option 3: Pre-submit hook

Add a rule that requires the agent to run compliance checks before declaring a tool as "ready." The `tool-creation-checklist.md` covers this.

### Option 4: Smoke test with a fresh session

The only way to truly verify is to start a new opencode session. This is expensive but definitive. Document as a final validation step.

## The Two-Verification Trap

Both bugs in this session shared a common pattern:

> We verified one thing (import paths) and assumed that meant the tool was correct in all dimensions.

| Round | What we verified | What we missed |
|-------|-----------------|---------------|
| 1 | Cross-tool imports fixed ✅ | Format still broken ❌ |
| 2 | No cross-tool imports ✅ | Format still broken ❌ (same as round 1) |

**Lesson**: Each fix dimension must be verified independently. Fixing imports does not fix format. Fixing format does not fix imports.

## Recommended Dev Workflow

```
1. Plan the tool
2. Create using template (tool-creation-checklist.md)
3. Verify:
   ├── grep for shebang         (must be absent)
   ├── grep for export default  (must be present)
   ├── grep for console.log     (must be absent)
   ├── grep import paths        (must be _lib/ only)
   ├── bun build --no-bundle    (must compile)
   └── bun run --help           (must work)
4. Commit
5. Start fresh session to confirm no startup errors
```
