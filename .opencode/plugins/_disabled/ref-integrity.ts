// @pluginclass TRNS
import { initDB, queryAll } from "../_lib/db"
import { validateRefIntegrity } from "../_lib/validate-refs"

const WATCHED_PATHS = [
  ".opencode/terms/",
  ".opencode/patterns/",
  ".opencode/skills/",
  ".opencode/commands/yamls/",
  ".opencode/rules/yamls/",
  ".opencode/protocols/",
]

export const RefIntegrity = async ({ client }: { client: any }) => {
  const run = async () => {
    const db = initDB()

    const termLinks = queryAll(db,
      "SELECT source_type, source_id, term_id AS target_id FROM entity_terms"
    ) as { source_type: string; source_id: string; target_id: string }[]
    const patternLinks = queryAll(db,
      "SELECT source_type, source_id, pattern_id AS target_id FROM entity_patterns"
    ) as { source_type: string; source_id: string; target_id: string }[]
    const validTermIds = queryAll(db, "SELECT id FROM terms").map(r => String(r.id))
    const validPatternIds = queryAll(db, "SELECT id FROM patterns").map(r => String(r.id))

    db.close()

    const report = validateRefIntegrity(termLinks, patternLinks, validTermIds, validPatternIds)

    if (report.orphanTerms.length > 0) {
      await client.app.log({
        body: {
          level: "warn",
          service: "ref-integrity",
          message: `Orphan term refs: ${report.orphanTerms.map(l => `${l.source_type} ${l.source_id} → ${l.target_id}`).join("; ")}`,
        },
      })
    }
    if (report.orphanPatterns.length > 0) {
      await client.app.log({
        body: {
          level: "warn",
          service: "ref-integrity",
          message: `Orphan pattern refs: ${report.orphanPatterns.map(l => `${l.source_type} ${l.source_id} → ${l.target_id}`).join("; ")}`,
        },
      })
    }
  }

  return {
    "file.edited": async ({ event }: { event: { filePath: string } }) => {
      if (!WATCHED_PATHS.some(p => event.filePath.includes(p))) return
      await run()
    },
    "tool.execute.after": async (input) => {
      if (input.tool !== "write-sync") return
      await run()
    },
  }
}
