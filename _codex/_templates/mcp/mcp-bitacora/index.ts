// mcp-bitacora — MCP server exposing the bitacora flow as agent tools.
// Delegates to the shared enabler wrapper/enabler/bitacora.sh (the
// alias-citing shim over the _shared/bin/bitacora Go binary). Tools:
//   bitacora_todo   {topic} ["{desc}"]            — open a task-todo record
//   bitacora_run    {name} [--trace] -- {cmd...}  — frame a command's output
//   bitacora_report {topic} ["{desc}"]            — open a task-report record
// Default-free: the Go binary owns all defaults; the server passes through
// only what the caller provides.

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { runEnabler } from "./_lib/bitacora-query.ts"

const server = new McpServer({ name: "mcp-bitacora", version: "1.0.0" })

function runAndReturn(args: string[], tool: string): { content: { type: "text"; text: string }[] } {
  const outcome = runEnabler(args)
  const text = outcome.ok ? outcome.stdout : `ERROR ${outcome.stderr || outcome.stdout}`
  return { content: [{ type: "text" as const, text }] }
}

server.registerTool(
  "bitacora_todo",
  {
    description: "Open a task-todo record under _codex/_bitacora/task-todo/. Result line: TODO=<path>. No-clobber per topic.",
    inputSchema: {
      topic: z.string().describe("Todo topic (slugified into the filename)"),
      desc: z.string().optional().describe("Project description (defaults to topic)"),
    },
  },
  async ({ topic, desc }) => {
    const args = ["todo", topic]
    if (desc) args.push(desc)
    return runAndReturn(args, "bitacora_todo")
  },
)

server.registerTool(
  "bitacora_report",
  {
    description: "Open a task-report record under _codex/_bitacora/task-report/. Result line: REPORT=<path>. No-clobber per topic.",
    inputSchema: {
      topic: z.string().describe("Report topic (slugified into the filename)"),
      desc: z.string().optional().describe("Project description (defaults to topic)"),
    },
  },
  async ({ topic, desc }) => {
    const args = ["report", topic]
    if (desc) args.push(desc)
    return runAndReturn(args, "bitacora_report")
  },
)

server.registerTool(
  "bitacora_run",
  {
    description: "Frame a command's output into _codex/_bitacora/task-stdout/ with # CMD:/# DATE:/# CWD: header and # DUR:/# exit: tail. Result: the framed stream; exit = the command's status.",
    inputSchema: {
      name: z.string().describe("Log name (slugified into the filename)"),
      command: z.array(z.string()).describe("The command to frame, e.g. ['cmake', '--build', 'build', '-j8']"),
      trace: z.boolean().optional().describe("Enrich through tracexec exec-tree when true (shell default applies when absent)"),
    },
  },
  async ({ name, command, trace }) => {
    const args = ["run", name]
    if (trace === true) args.push("--trace")
    args.push("--", ...command)
    return runAndReturn(args, "bitacora_run")
  },
)

async function main(): Promise<void> {
  const transport = new StdioServerTransport()
  await server.connect(transport)
}

main().catch((err) => {
  console.error("mcp-bitacora fatal:", err)
  process.exit(1)
})
