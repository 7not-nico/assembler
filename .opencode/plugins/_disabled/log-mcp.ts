// @pluginclass TRNS
import { initMCPDB } from "../_lib/db"

const MCP_TOOLS = new Set([
  "exa_web_search_exa", "exa_web_fetch_exa",
  "parallel-search_web_search", "parallel-search_web_fetch",
  "websearch", "webfetch",
])

function parseTool(tool: string): { mcp: string; name: string } {
  if (tool.startsWith("exa_")) return { mcp: "exa", name: tool }
  if (tool.startsWith("parallel-search_")) return { mcp: "parallel", name: tool }
  return { mcp: tool, name: tool }
}

function extractQuery(tool: string, args: any): string {
  if (["exa_web_search_exa", "websearch"].includes(tool)) return String(args.query ?? "")
  if (tool === "parallel-search_web_search") return (args.search_queries ?? []).join("; ")
  if (["exa_web_fetch_exa", "parallel-search_web_fetch"].includes(tool)) return (args.urls ?? []).join(", ")
  if (tool === "webfetch") return String(args.url ?? "")
  return JSON.stringify(args)
}

function extractCount(tool: string, args: any): number | null {
  if (["exa_web_search_exa", "websearch"].includes(tool)) return args.numResults ?? null
  if (tool === "exa_web_fetch_exa") return args.maxCharacters ?? null
  return null
}

function summarize(text: string): string | null {
  if (!text) return null
  return text.length > 200 ? text.slice(0, 200) + "…" : text
}

export const LogMcp = async ({ client }: { client: any }) => {
  return {
    "tool.execute.after": async (input, output) => {
      if (!MCP_TOOLS.has(input.tool)) return

      const { mcp, name: toolName } = parseTool(input.tool)
      const query = extractQuery(input.tool, input.args)
      const resultCount = extractCount(input.tool, input.args)
      const summary = summarize(output.output)

      try {
        const db = initMCPDB()
        db.query(`INSERT INTO mcp_searches (mcp, tool, query, result_summary, result_count, status, error_code)
                  VALUES ($mcp, $tool, $query, $summary, $resultCount, $status, $errorCode)`)
          .run({ $mcp: mcp, $tool: toolName, $query: query, $summary: summary, $resultCount: resultCount, $status: "success", $errorCode: null })
        db.close()
      } catch (e) {
        await client.app.log({
          body: {
            level: "error",
            service: "log-mcp",
            message: `Failed to log ${input.tool}: ${(e as Error).message}`,
          },
        })
      }
    },
  }
}
