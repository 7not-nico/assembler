// @toolclass SGNL
import { tool } from "@opencode-ai/plugin"
import { initMCPDB, queryAll, queryOne } from "../_lib/db"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "Verify MCP search results by cross-referencing across MCPs",
  args: {
    "search-id": tool.schema.number().int().optional().describe("Verify specific search"),
    latest: tool.schema.boolean().optional().describe("Verify latest unverified searches"),
    all: tool.schema.boolean().optional().describe("Verify all searches"),
    limit: tool.schema.number().int().optional().describe("Max searches for --latest (default 5)"),
  },
  async execute(args) {
    crashOnError()
    const modes = [args["search-id"], args.latest, args.all].filter(Boolean)
    if (modes.length !== 1) throw new Error("Exactly one mode required: --search-id, --latest, or --all")
    const db = initMCPDB()
    const activeRow = queryOne(db, "SELECT COUNT(*) as cnt FROM mcp_features WHERE active = 1")
    const activeMCPs = (activeRow?.cnt as number) ?? 0
    let searchIds: number[] = []
    if (args["search-id"]) {
      const s = queryOne(db, "SELECT id FROM mcp_searches WHERE id = $id", { $id: args["search-id"] })
      if (!s) throw new Error(`Search #${args["search-id"]} not found.`)
      searchIds = [args["search-id"]]
    } else if (args.latest) {
      const limit = args.limit ?? 5
      const rows = queryAll(db,
        `SELECT s.id FROM mcp_searches s
         WHERE NOT EXISTS (SELECT 1 FROM mcp_results r JOIN mcp_signal sig ON sig.result_id = r.id WHERE r.search_id = s.id)
         ORDER BY s.timestamp DESC LIMIT $limit`,
        { $limit: limit })
      searchIds = rows.map(r => r.id as number)
    } else if (args.all) {
      const rows = queryAll(db, "SELECT id FROM mcp_searches ORDER BY timestamp DESC")
      searchIds = rows.map(r => r.id as number)
    }
    let totalResults = 0
    for (const sid of searchIds) {
      const results = queryAll(db, "SELECT id, url FROM mcp_results WHERE search_id = $searchId", { $searchId: sid })
      for (const r of results) {
        const consensusRows = queryAll(db,
          `SELECT DISTINCT s.mcp FROM mcp_results r
           JOIN mcp_searches s ON s.id = r.search_id
           WHERE r.url = $url`, { $url: r.url })
        const distinctMCPs = consensusRows.length
        const consensusScore = activeMCPs > 0 ? Math.min(distinctMCPs / activeMCPs, 1.0) : 0.0
        const score = consensusScore
        const details = JSON.stringify({
          consensus_mcps: distinctMCPs,
          active_mcps: activeMCPs,
          url: r.url,
        })
        db.query(`INSERT OR REPLACE INTO mcp_signal (result_id, score, consensus_score, details) VALUES ($resultId, $score, $consensusScore, $details)`).run({
          $resultId: r.id,
          $score: score,
          $consensusScore: consensusScore,
          $details: details,
        })
        totalResults++
      }
    }
    db.close()
    return `Verified ${totalResults} results across ${searchIds.length} searches.`
  },
})
