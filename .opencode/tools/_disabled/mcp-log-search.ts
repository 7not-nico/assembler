// @toolclass GENR
import { tool } from "@opencode-ai/plugin"
import { initMCPDB, queryOne } from "../_lib/db"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "Log an MCP search to the database",
  args: {
    mcp: tool.schema.string().describe("MCP name"),
    tool: tool.schema.string().describe("Tool name"),
    query: tool.schema.string().describe("Search query"),
    summary: tool.schema.string().optional().describe("Result summary"),
    status: tool.schema.string().optional().describe("Status (success or error)"),
    "error-code": tool.schema.string().optional().describe("Error code"),
    "result-count": tool.schema.number().int().optional().describe("Number of results"),
    urls: tool.schema.string().optional().describe("JSONC array of {url, title?, snippet?}"),
  },
  async execute(args) {
    crashOnError()
    const db = initMCPDB()
    const insertSql = `INSERT INTO mcp_searches (mcp, tool, query, result_summary, result_count, status, error_code) VALUES ($mcp, $tool, $query, $summary, $resultCount, $status, $errorCode)`
    db.query(insertSql).run({
      $mcp: args.mcp,
      $tool: args.tool,
      $query: args.query,
      $summary: args.summary ?? null,
      $resultCount: args["result-count"] ?? null,
      $status: args.status ?? "success",
      $errorCode: args["error-code"] ?? null,
    })
    const row = queryOne(db, "SELECT last_insert_rowid() as id")
    const searchId = row!.id as number
    let suffix = ""
    if (args.urls) {
      try {
        const urls = JSON.parse(args.urls) as { url: string; title?: string; snippet?: string }[]
        for (let i = 0; i < urls.length; i++) {
          const u = urls[i]
          db.query(`INSERT INTO mcp_results (search_id, url, title, snippet, position) VALUES ($searchId, $url, $title, $snippet, $position)`).run({
            $searchId: searchId,
            $url: u.url,
            $title: u.title ?? null,
            $snippet: u.snippet ?? null,
            $position: i + 1,
          })
        }
        suffix = ` + ${urls.length} results`
      } catch (e) {
        suffix = ` [url parse error: ${(e as Error).message}]`
      }
    }
    db.close()
    return `Logged search #${searchId} (${args.mcp}/${args.tool})${suffix}`
  },
})
