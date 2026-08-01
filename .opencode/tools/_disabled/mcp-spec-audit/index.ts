#!/usr/bin/env bun
// exports: (none — CLI entrypoint)
// purity: io
// depends-on: spec-rules, spec-audit, spec-format, @modelcontextprotocol/sdk, zod

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { loadRules } from "../../_lib/spec-rules"
import { auditText } from "../../_lib/spec-audit"
import { formatAuditReport, formatRuleList } from "../../_lib/spec-format"

const server = new McpServer({ name: "mcp-spec-audit", version: "1.0.0" })

server.tool(
  "spec_audit",
  "Audit text content against PROT.LLM.SPECIFICATION rules. Returns compliance score and violations.",
  { text: z.string().describe("LLM-facing instruction text to audit") },
  async (args) => {
    const rules = loadRules()
    const result = auditText(args.text, rules)
    const text = formatAuditReport(result)
    return { content: [{ type: "text" as const, text }] }
  }
)

server.tool(
  "spec_audit_file",
  "Audit a file against PROT.LLM.SPECIFICATION rules by path. Reads file, returns compliance score and violations.",
  { path: z.string().describe("Absolute path to instruction file") },
  async (args) => {
    const { readFileSync } = await import("fs")
    const fileText = readFileSync(args.path, "utf-8")
    const rules = loadRules()
    const result = auditText(fileText, rules)
    const report = formatAuditReport(result)
    return { content: [{ type: "text" as const, text: `File: ${args.path}\n${report}` }] }
  }
)

server.tool(
  "spec_rules",
  "List all enabled LLM specification rules with descriptions.",
  {},
  async () => {
    const rules = loadRules()
    const text = formatRuleList(rules)
    return { content: [{ type: "text" as const, text }] }
  }
)

const transport = new StdioServerTransport()
await server.connect(transport)
