// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initMCPDB, queryAll } from "../_lib/db"
import { crashOnError } from "../_lib/errors"
import { SEPARATOR } from "../_lib/paths"

const STOP_WORDS = new Set([
  "how", "what", "why", "docker", "container", "linux", "config",
  "setup", "guide", "tutorial", "docs", "documentation",
])

function normalizeQuery(q: string): string {
  const words = q.toLowerCase().split(/\s+/)
  for (const w of words) {
    if (!STOP_WORDS.has(w)) return w
  }
  return words[0] || q
}

export default tool({
  description: "Compare MCP search results by query group",
  args: {
    mcp: tool.schema.string().optional().describe("Filter by MCP name"),
    limit: tool.schema.number().int().optional().describe("Max searches to show (default 50)"),
  },
  async execute(args) {
    crashOnError()
    const db = initMCPDB()
    const limit = args.limit ?? 50
    const params: Record<string, unknown> = { $mcp: args.mcp ?? null, $limit: limit }
    const rows = queryAll(db,
      `SELECT id, mcp, tool, query, result_summary, status,
              error_code, result_count, timestamp
       FROM mcp_searches
       WHERE ($mcp IS NULL OR mcp = $mcp)
       ORDER BY timestamp DESC
       LIMIT $limit`, params)
    db.close()
    if (rows.length === 0) throw new Error("No searches found.")
    const groups: Record<string, typeof rows> = {}
    for (const r of rows) {
      const key = normalizeQuery(r.query as string)
      if (!groups[key]) groups[key] = []
      groups[key].push(r)
    }
    let out = ""
    for (const [key, searches] of Object.entries(groups).sort()) {
      out += `Query: ${key}\n`
      out += `${SEPARATOR}\n`
      for (const s of searches) {
        const mcpTool = `${s.mcp}/${s.tool}`
        const count = s.result_count != null ? String(s.result_count) : "-"
        out += `  ${mcpTool.padEnd(25)} ${String(s.status ?? "").padEnd(10)} ${count.padEnd(8)} — ${s.result_summary ?? ""}\n`
      }
      out += "\n"
    }
    const summary: Record<string, { calls: number; success: number; totalResults: number }> = {}
    for (const r of rows) {
      const mcp = r.mcp as string
      if (!summary[mcp]) summary[mcp] = { calls: 0, success: 0, totalResults: 0 }
      summary[mcp].calls++
      if (r.status === "success") summary[mcp].success++
      summary[mcp].totalResults += (r.result_count as number) || 0
    }
    out += "Summary\n"
    out += `${SEPARATOR}\n`
    for (const [mcp, stats] of Object.entries(summary).sort()) {
      const successPct = stats.calls > 0 ? ((stats.success / stats.calls) * 100).toFixed(0) : "0"
      const avgResults = stats.calls > 0 ? (stats.totalResults / stats.calls).toFixed(1) : "0.0"
      out += `  ${mcp}: ${stats.calls} calls, ${successPct}% success, avg ${avgResults} results/call\n`
    }
    return out
  },
})
