// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initMCPDB, queryAll } from "../_lib/db"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "Show MCP feature comparison",
  args: {
    mcp: tool.schema.string().optional().describe("Filter by MCP name (exa, parallel, brave)"),
  },
  async execute(args) {
    crashOnError()
    const db = initMCPDB()
    let sql = "SELECT * FROM mcp_features"
    const params: Record<string, string> = {}
    if (args.mcp) {
      sql += " WHERE mcp = $mcp"
      params.$mcp = args.mcp
    }
    sql += " ORDER BY mcp"
    const rows = queryAll(db, sql, params)
    db.close()
    if (rows.length === 0) throw new Error("No MCP features found.")
    let out = "MCP Features\n" + "=".repeat(60) + "\n"
    for (const r of rows) {
      out += `\n${r.mcp}\n`
      out += `  Active:          ${r.active ? "yes" : "no"}\n`
      out += `  Pricing:         ${r.pricing}\n`
      out += `  Default results: ${r.default_results ?? "-"}\n`
      if (r.source_types) out += `  Source types:    ${r.source_types}\n`
      if (r.data_format) out += `  Data format:     ${r.data_format}\n`
      out += `  Strengths:       ${r.strengths ?? "-"}\n`
      out += `  Weaknesses:      ${r.weaknesses ?? "-"}\n`
    }
    return out
  },
})
