#!/usr/bin/env bun
// exports: (none — CLI entrypoint)
// purity: io
// depends-on: compartment-query, compartment-audit, compartment-format, @modelcontextprotocol/sdk, zod

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { join } from "path"
import { findSubprojects, readCompartmentYaml, readAgentsMd } from "../../_lib/compartment-query"
import { parseCompartmentYaml, auditDeclaration, auditCompartmentText } from "../../_lib/compartment-audit"
import { formatAuditResult, formatAuditReportAll } from "../../_lib/compartment-format"
import type { AuditResult } from "../../_lib/compartment-audit"

const ROOT = join(import.meta.dir, "..", "..", "..")

function auditProject(name: string, path: string): AuditResult {
  const yamlText = readCompartmentYaml(path)
  if (!yamlText) {
    return { name, path, present: false, violations: [] }
  }
  const decl = parseCompartmentYaml(yamlText)
  if (!decl) {
    return { name, path, present: true, violations: [{ field: "(root)", message: "Unable to parse compartment.yaml" }] }
  }
  const violations = auditDeclaration(decl)
  return { name, path, present: true, violations }
}

const server = new McpServer({ name: "mcp-compartment-audit", version: "1.0.0" })

server.tool(
  "compartment_scan_all",
  "Scan all subprojects for compartment.yaml and audit compliance against REF.META.COMPARTMENT.SPECIALIZATION rules.",
  {},
  async () => {
    const projects = findSubprojects(ROOT)
    const results = projects.map(p => auditProject(p.name, p.path))
    const text = formatAuditReportAll(results)
    return { content: [{ type: "text" as const, text }] }
  }
)

server.tool(
  "compartment_scan_path",
  "Audit a single subproject at the given path.",
  { path: z.string().describe("Absolute path to subproject directory") },
  async (args) => {
    const name = args.path.split("/").filter(Boolean).pop() || "unknown"
    const result = auditProject(name, args.path)
    const text = formatAuditResult(result)
    return { content: [{ type: "text" as const, text }] }
  }
)

server.tool(
  "compartment_check_text",
  "Validate a raw YAML compartment declaration text against REF.META.COMPARTMENT.SPECIALIZATION rules.",
  { text: z.string().describe("YAML declaration text from compartment.yaml") },
  async (args) => {
    const violations = auditCompartmentText(args.text)
    const result: AuditResult = { name: "(input)", path: "(input)", present: true, violations }
    const text = formatAuditResult(result)
    return { content: [{ type: "text" as const, text }] }
  }
)

const transport = new StdioServerTransport()
await server.connect(transport)
