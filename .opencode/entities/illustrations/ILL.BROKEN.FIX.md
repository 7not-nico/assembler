---
id: ILL.BROKEN.FIX
title: "Broken Window — Fix Cascade from One Lint Warning"
source: PROT.TOOL.COMPLIANCE
summary: "A single unfixed lint warning in a sync tool spawns two more within the same session. The restoration: fix all three, then validate at every gate."
illustration: "One unfixed lint warning in a sync tool becomes three within the session — the agent fixes the cascade, runs validate, and locks the gate."
illustrates: [MAX.BROKEN.WINDOW.CASCADE]
tags: walkthrough,cascade,bug,fix,validation,quality
related: [MAX.CODE.DRY.PRINCIPLE, MAX.CODE.ORTHOGONALITY.PRINCIPLE]
---
## Context

`MAX.BROKEN.WINDOW.CASCADE` warns that an unfixed issue invites more. A sync tool in `.opencode/tools/` has a type lint warning — `any` used where a union type fits. The agent decides to defer it. Within the same session, two more warnings appear: an unused import in the same file and a missing return type in an adjacent file. Each broken window lowers the threshold for the next one.

## Walkthrough

### Step 1: First broken window — deferred `any`

The `read-projection` tool handler returns `any` from its response body:

```ts
function formatBody(body: any): string {
```

Inline fix: replace `any` with `Record<string, unknown>`. The fix takes 10 seconds. Instead, the agent notes a FIXME and moves on.

### Step 2: Second broken window — unused import

Five lines later, the agent adds a new handler that imports `Database` from `bun:sqlite`:

```ts
import { Database } from "bun:sqlite";
```

The handler is a refactor placeholder — `Database` is never used. The first lint run would flag this. The unused import is a direct consequence of the first deferred fix: the agent's standard for "acceptable to defer" lowered from "type issue" to "dead import."

### Step 3: Third broken window — missing return type

In an adjacent file, a new `formatList` function lacks a return type annotation:

```ts
function formatList(items: string[]) {
```

The pattern is clear: each broken window lowers the threshold. The first deferral normalizes deferral.

### Step 4: Fix all three in one pass

The agent stops and runs:

```bash
bun --check
```

Three warnings appear. The agent fixes all three — no deferrals:

1. `any` → `Record<string, unknown>`
2. Remove unused `Database` import
3. Add `: string` return type to `formatList`

### Step 5: Lock the gate

The agent adds a pre-sync validation step:

```bash
bun --check .opencode/tools/ && write-sync --type all
```

Validation runs before every sync. No more broken windows.

## Key insight

A single deferred quality issue normalizes deferral. Within one session, the standard drops from "fix type issue" to "skip dead import" to "omit return type." The fix is not to fix each window individually — the fix is to close all broken windows in the current session boundary and validate at every gate so no new window opens.

## See also

- `MAX.BROKEN.WINDOW.CASCADE` — the maxim this illustrates
- `MAX.CODE.DRY.PRINCIPLE` — single source of truth prevents duplicate definitions that become broken windows
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — orthogonal tools reduce cross-file cascade
