---
id: ILL.PROGRAMMING.EXPLAIN
title: "Programming Deliberately — Explaining a Bug Before Fixing"
source: PROT.TOOL.HOOKS
summary: "A sync tool produces duplicate rows. Instead of guessing the fix, the agent writes down the hypothesized root cause, traces the data flow, then applies the targeted fix."
illustration: "A write-sync tool duplicates rows on rerun — the agent writes the hypothesis (no upsert check), traces the INSERT path in lib/sync.ts, confirms the missing UPSERT, fixes it, and verifies idempotency."
illustrates: [MAX.PROGRAMMING.DELIBERATELY.PRACTICE]
tags: walkthrough,debugging,discipline,trace,explain,root-cause
related: [MAX.CODE.DRY.PRINCIPLE, MAX.BROKEN.WINDOW.CASCADE]
---
## Context

`MAX.PROGRAMMING.DELIBERATELY.PRACTICE` says to know what should happen before writing code and to explain why it worked or failed. A `write-sync` tool produces duplicate rows when run twice against the same entity. The agent is tempted to add a `DELETE before INSERT` — a common guess. Instead, the agent explains the failure before applying any change.

## Walkthrough

### Step 1: Write down the hypothesis

Before looking at code, the agent states:

> Hypothesis: `write-sync` uses `INSERT` without an upsert clause. The first run inserts the entity. The second run inserts a duplicate because no primary key conflict check exists in the sync function.

### Step 2: Trace the data flow to confirm

The agent reads `lib/sync.ts` and traces the INSERT path:

```ts
function syncEntity(entity: Entity) {
  db.run("INSERT INTO entities (id, title, body) VALUES (?, ?, ?)", [
    entity.id,
    entity.title,
    entity.body,
  ]);
}
```

Confirmed: plain INSERT, no `ON CONFLICT`, no `REPLACE`, no pre-check `SELECT`. The hypothesis is correct.

### Step 3: Explain why the fix works before applying

The agent states the fix:

> Fix: change INSERT to `INSERT OR REPLACE` (SQLite upsert). On conflict, the existing row is replaced with new values. The second run becomes idempotent — same data, same result. No DELETE needed.

This explanation captures the mechanism (upsert), the scope (one clause), and the invariants (idempotent, no data loss).

### Step 4: Apply the fix

```ts
db.run(
  "INSERT OR REPLACE INTO entities (id, title, body) VALUES (?, ?, ?)",
  [entity.id, entity.title, entity.body]
);
```

### Step 5: Verify idempotency

```bash
bun run write-sync --type terms
bun run write-sync --type terms  # rerun
```

Second run produces no duplicates. The tool is now idempotent.

### Step 6: Accept only code you can explain

The agent adds a short comment above the upsert:

```
-- INSERT OR REPLACE ensures idempotent reruns
```

If asked "why upsert?", the answer is clear: the hypothesis said the INSERT had no conflict handling; the trace confirmed it; the upsert makes the second run produce the same result as the first.

## Key insight

A blind "DELETE before INSERT" would have fixed the symptom but introduced a race condition and lost the old row's data on conflict. The deliberate approach — hypothesis, trace, explain, fix, verify — produced a correct upsert that preserves idempotency without data loss. The key discipline is writing down the hypothesis before touching code and confirming the explanation before applying the change.

## See also

- `MAX.PROGRAMMING.DELIBERATELY.PRACTICE` — the maxim this illustrates
- `MAX.CODE.DRY.PRINCIPLE` — a single authoritative sync function prevents duplicate fix attempts
- `MAX.BROKEN.WINDOW.CASCADE` — unfixed idempotency invites sync data rot
