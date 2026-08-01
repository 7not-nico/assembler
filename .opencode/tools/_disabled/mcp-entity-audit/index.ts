#!/usr/bin/env bun
// exports: (none — CLI entrypoint)
// purity: io
// depends-on: entity-audit, entity-format, @modelcontextprotocol/sdk, zod

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { readFileSync, readdirSync } from "fs"
import { join } from "path"
import { auditProtocolBody, auditPatternBody, auditEntityFile } from "../../_lib/entity-audit"
import { formatEntityReport, formatEntityReportAll } from "../../_lib/entity-format"
import type { AuditResult } from "../../_lib/entity-audit"

const ROOT = join(import.meta.dir, "..", "..")
const PROTOCOLS_DIR = join(ROOT, "protocols")
const PATTERNS_DIR = join(ROOT, "patterns")
const MAXIMS_DIR = join(ROOT, "maxims")

const server = new McpServer({ name: "mcp-entity-audit", version: "1.0.0" })

server.tool(
  "entity_audit",
  "Audit text content against PAT.ENTITY.DISTINCTION rules. Returns classification compliance score and violations.",
  { text: z.string().describe("File text to audit"), type: z.enum(["protocol", "pattern", "maxim"]).describe("Entity type: protocol, pattern, or maxim") },
  async (args) => {
    const violations = args.type === "protocol" || args.type === "maxim" ? auditProtocolBody(args.text) : auditPatternBody(args.text)
    const score = violations.length === 0 ? 100 : Math.max(0, 100 - violations.length * 20)
    const result: AuditResult = { path: "(input)", type: args.type, score, violations }
    const text = formatEntityReport(result)
    return { content: [{ type: "text" as const, text }] }
  }
)

server.tool(
  "entity_audit_file",
  "Audit a single file against PAT.ENTITY.DISTINCTION rules by path. Returns compliance score and violations.",
  { path: z.string().describe("Absolute path to entity file (.md)") },
  async (args) => {
    const fileText = readFileSync(args.path, "utf-8")
    const result = auditEntityFile(args.path, fileText)
    const text = formatEntityReport(result)
    return { content: [{ type: "text" as const, text }] }
  }
)

server.tool(
  "entity_audit_all",
  "Audit all protocol, pattern, and maxim files in .opencode/. Returns aggregate compliance report.",
  {},
  async () => {
    const results: AuditResult[] = []

    const protoFiles = readdirSync(PROTOCOLS_DIR).filter(f => f.endsWith(".md")).sort()
    for (const f of protoFiles) {
      const filePath = join(PROTOCOLS_DIR, f)
      const text = readFileSync(filePath, "utf-8")
      results.push(auditEntityFile(filePath, text))
    }

    const patFiles = readdirSync(PATTERNS_DIR).filter(f => f.endsWith(".md")).sort()
    for (const f of patFiles) {
      const filePath = join(PATTERNS_DIR, f)
      const text = readFileSync(filePath, "utf-8")
      results.push(auditEntityFile(filePath, text))
    }

    const maxFiles = readdirSync(MAXIMS_DIR).filter(f => f.endsWith(".md")).sort()
    for (const f of maxFiles) {
      const filePath = join(MAXIMS_DIR, f)
      const text = readFileSync(filePath, "utf-8")
      results.push(auditEntityFile(filePath, text))
    }

    const text = formatEntityReportAll(results)
    return { content: [{ type: "text" as const, text }] }
  }
)

const transport = new StdioServerTransport()
await server.connect(transport)
