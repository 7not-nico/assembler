// @pluginclass TRNS
import { initDB, queryAll } from "../_lib/db"
import { validateEventUsage } from "../_lib/validate-events"

export const AuditEvents = async ({ client }: { client: any }) => {
  const run = async () => {
    const db = initDB()
    const allEventIds = queryAll(db, "SELECT id FROM events").map(r => String(r.id))
    const currentLinks = queryAll(db, "SELECT event_id, person_id FROM person_events") as { event_id: string; person_id: string }[]
    db.close()

    const report = validateEventUsage(allEventIds, currentLinks)

    if (report.unused.length > 0) {
      await client.app.log({
        body: {
          level: "warn",
          service: "audit-events",
          message: `Unused events (no person links): ${report.unused.join(", ")}`,
        },
      })
    }
    if (report.lonely.length > 0) {
      await client.app.log({
        body: {
          level: "info",
          service: "audit-events",
          message: `Lonely events (single person): ${report.lonely.map(l => `${l.event} → ${l.person}`).join(", ")}`,
        },
      })
    }
  }

  return {
    "file.edited": async ({ event }: { event: { filePath: string } }) => {
      if (!event.filePath.includes("02-events.sql") && !event.filePath.includes(".opencode/persons/")) return
      await run()
    },
    "tool.execute.after": async (input) => {
      if (!["write-sync", "read-validate"].includes(input.tool)) return
      await run()
    },
  }
}
