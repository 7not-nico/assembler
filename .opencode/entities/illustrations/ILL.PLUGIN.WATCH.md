---
id: ILL.PLUGIN.WATCH
title: "Validation Plugin Walkthrough — Pure Logic and Lifecycle Hooks for Event Integrity"
source: PROT.PLUGIN.WRITE
summary: "Walk through setting up a validation plugin: pure detection function in _lib/validate-events.ts, plugin in plugins/audit-events.ts with file.edited and tool.execute.after hooks, and structured logging for violations."
illustration: "An agent sets up an event usage validation plugin — pure logic in _lib/validate-events.ts detects orphan events, plugin in plugins/audit-events.ts wires file.edited and tool.execute.after hooks, logs violations via client.app.log()"
illustrates: [PROT.PLUGIN.LIFECYCLE]
tags: plugin,validation,walkthrough,lifecycle,integrity,logging
related: [PROT.TOOL.HOOKS, REF.LIB.PURITY.BOUNDARY, PROT.PERSON.SCHEMA]
---
## Context

The person event timeline schema has unused events — events defined in seed data with zero persons referencing them. A validation plugin catches these automatically after each `file.edited` or `tool.execute.after` event.

## Walkthrough

### Step 1: Pure detection logic in _lib/

The agent creates `_lib/validate-events.ts` — a pure function that accepts data and returns a report with no I/O side effects:

```ts
export function validateEventUsage(events: Event[], persons: PersonEvent[]): ValidationReport {
  const violations: string[] = []
  const usedEventIds = new Set(persons.map(p => p.event_id))
  for (const event of events) {
    if (!usedEventIds.has(event.id)) {
      violations.push(`Event ${event.name} (id ${event.id}) has zero persons referencing it`)
    }
  }
  return { violations, advisories: [] }
}

interface ValidationReport {
  violations: string[]
  advisories: string[]
}
```

The function is deterministic — same input, same output. No database calls, no file I/O. Testable without `bun:sqlite`.

### Step 2: Plugin in plugins/ importing logic

The agent creates `plugins/audit-events.ts` — the IO layer that imports the pure logic and wires lifecycle hooks:

```ts
// @pluginclass TRNS
import { validateEventUsage } from "../_lib/validate-events"

export const AuditEvents = async function({ client }) {
  return {
    "file.edited": async ({ path }) => {
      if (!path.endsWith("seed-events.sql")) return

      const db = new Database(".opencode/patlib.db")
      const events = db.query("SELECT * FROM person_events").all()
      const persons = db.query("SELECT * FROM person_event_junction").all()
      const report = validateEventUsage(events, persons)

      for (const v of report.violations) {
        await client.app.log({ body: { service: "audit-events", level: "warn", message: v } })
      }
    },
    "tool.execute.after": async ({ tool }) => {
      if (tool !== "write-sync") return

      const db = new Database(".opencode/patlib.db")
      const events = db.query("SELECT * FROM person_events").all()
      const persons = db.query("SELECT * FROM person_event_junction").all()
      const report = validateEventUsage(events, persons)

      for (const v of report.violations) {
        await client.app.log({ body: { service: "audit-events", level: "warn", message: v } })
      }
      if (report.violations.length === 0) {
        await client.app.log({ body: { service: "audit-events", level: "info", message: "All events referenced" } })
      }
    }
  }
}
```

### Step 3: Plugin triggers

| Trigger | When | What plugin does |
|---------|------|------------------|
| User edits seed-events.sql | `file.edited` | Loads data, calls `validateEventUsage`, logs violations |
| Agent runs write-sync | `tool.execute.after` | Same check, plus info log when clean |

### Step 4: Plugin output

When an orphan event exists, the opencode log stream shows:

```
[audit-events] warn: Event Birth (id 3) has zero persons referencing it
[audit-events] info: All events referenced
```

Severity levels per protocol rule 4: `warn` for violations, `info` for advisory, `error` for plugin failure.

## Key insight

The validation plugin splits responsibility: pure logic (`_lib/`) handles detection, the plugin (`plugins/`) handles I/O and lifecycle wiring. The pure function is independently testable without `bun:sqlite`. The hooks-only design (no `tool:` registration) keeps the plugin invisible to the LLM tool surface — validation runs automatically on relevant events.

## See also

- `PROT.PLUGIN.LIFECYCLE` — the validation plugin protocol this walkthrough illustrates
- `PROT.TOOL.HOOKS` — general plugin lifecycle hooks architecture
- `REF.LIB.PURITY.BOUNDARY` — pure vs IO separation pattern
- `PROT.PERSON.SCHEMA` — person event timeline, consumer of event validation
