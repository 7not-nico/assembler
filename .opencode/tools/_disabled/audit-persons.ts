// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initDB, queryAll } from "../_lib/db"
import { crashOnError } from "../_lib/errors"
import { readdirSync, readFileSync } from "fs"
import { join } from "path"
import { PERSONS_DIR } from "../_lib/paths"
import { extractFrontmatter } from "../_lib/parse"
import { detectPersonStaleness, OrphanReport } from "../_lib/validate-persons"

export default tool({
  description: "Audit persons entities for staleness: find orphaned event links and unused event definitions",
  args: {},
  async execute() {
    crashOnError()
    const db = initDB()

    // 1. Collect all active Person IDs from the filesystem
    const files = readdirSync(PERSONS_DIR).filter(f => f.endsWith(".md"))
    const activePersonIds: string[] = []
    for (const file of files) {
      const text = readFileSync(join(PERSONS_DIR, file), "utf-8")
      const r = extractFrontmatter(text)
      if (r && r.fm.id) activePersonIds.push(String(r.fm.id))
    }

    // 2. Get all current links from DB
    const currentLinks = queryAll(db, "SELECT person_id, event_id FROM person_events") as { person_id: string; event_id: string }[]

    // 3. Get all event definitions from DB
    const allEventIds = queryAll(db, "SELECT id FROM events").map(r => String(r.id))

    db.close()

    // 4. Run pure validation logic
    const report: OrphanReport = detectPersonStaleness(activePersonIds, currentLinks, allEventIds)

    // 5. Format output
    let out = `Person Staleness Audit\n${"=".repeat(20)}\n`
    
    if (report.staleLinks.length > 0) {
      out += `\nStale Links (Person no longer exists on disk):\n`
      report.staleLinks.forEach(link => out += `  - ${link}\n`)
    } else {
      out += `\nNo stale person links found.\n`
    }

    if (report.orphanedEvents.length > 0) {
      out += `\nOrphaned Events (Not referenced by any active person):\n`
      report.orphanedEvents.forEach(id => out += `  - ${id}\n`)
    } else {
      out += `\nNo orphaned event definitions found.\n`
    }

    return out
  },
})
