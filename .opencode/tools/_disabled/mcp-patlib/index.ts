#!/usr/bin/env bun
// exports: (none — CLI entrypoint)
// purity: io
// depends-on: mcp-query, mcp-format, db, @modelcontextprotocol/sdk, zod

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { initDB } from "../../_lib/db"
import { searchEntities, getEntityDetail, validateEntities, findIllustrations } from "../../_lib/mcp-query"
import { formatSearchResults, formatEntityDetail, formatValidationReport, formatIllustrationPairs } from "../../_lib/mcp-format"
import { ENTITY_TYPES, VALID_STATE_PROFILES } from "../../_lib/mcp-types"

const server = new McpServer({ name: "patlib", version: "1.0.0" })

server.tool(
  "patlib_search",
  "Search patlib entities by type, tag, text query, source, or status. Returns matching IDs with titles and metadata.",
  {
    type: z.enum(ENTITY_TYPES).optional().describe("Entity type — terms (default), patterns, cognitions, concepts, definitions, skills, rules, apologias, commands, protocols, abstractions, persons, illustrations"),
    query: z.string().max(200).optional().describe("Free-text search across ID, title, tags, summary, principle, related"),
    tag: z.string().max(50).optional().describe("Exact tag match"),
    source: z.string().optional().describe("Filter by source (exact match)"),
    status: z.string().optional().describe("Filter by status (active, draft) — patterns and protocols only"),
    state_profile: z.enum(VALID_STATE_PROFILES).optional().describe("Filter by state_profile — skills only"),
    limit: z.number().int().min(1).max(100).optional().default(50).describe("Max results"),
    offset: z.number().int().min(0).optional().default(0).describe("Skip N results"),
  },
  async (args) => {
    const db = initDB()
    try {
      const entityType = args.type ?? "terms"
      const rows = searchEntities(db, entityType, args)
      const text = formatSearchResults(rows, entityType)
      return { content: [{ type: "text" as const, text }] }
    } finally {
      db.close()
    }
  }
)

server.tool(
  "patlib_get",
  "Show full details for a patlib entity by ID — returns the complete body with metadata (summary, principle, source, tags, related, etc.).",
  {
    id: z.string().regex(/^[A-Z][A-Z0-9]*(\.[A-Z][A-Z0-9]*)+$/, "ID format: TYPE.SEGMENT(.SEGMENT)*").describe("Entity ID (e.g. MAX.DRY, PER.EDSGER.W.DIJKSTRA)"),
    type: z.enum(ENTITY_TYPES).optional().describe("Entity type hint — terms (default), patterns, cognitions, concepts, definitions, skills, rules, apologias, commands, protocols, abstractions, persons"),
  },
  async (args) => {
    const db = initDB()
    try {
      const entityType = args.type ?? "terms"
      const detail = getEntityDetail(db, entityType, args.id)
      const text = formatEntityDetail(detail, entityType)
      return { content: [{ type: "text" as const, text }] }
    } finally {
      db.close()
    }
  }
)

server.tool(
  "patlib_validate",
  "Validate all patlib entity files (patterns, terms, skills, apologias, protocols, persons, illustrations, maxims) for structural correctness. Reports violations per file.",
  {},
  async () => {
    const db = initDB()
    try {
      const result = validateEntities(db)
      const text = formatValidationReport(result)
      return { content: [{ type: "text" as const, text }] }
    } finally {
      db.close()
    }
  }
)

server.tool(
  "patlib_illustrations",
  "Query illustration-to-entity relationships. Returns pairs linking illustrations to the patterns, protocols, or other entities they illustrate.",
  {
    entity_id: z.string().optional().describe("Filter to illustrations that illustrate this entity (e.g. PAT.META.RENAME.REGISTRY)"),
    illustration_id: z.string().optional().describe("Show entities illustrated by a specific illustration (e.g. ILL.META.RENAME.REGISTRY)"),
    entity_type: z.enum(["patterns", "protocols", "terms", "rules", "skills", "commands", "apologias", "abstractions", "persons", "illustrations"]).optional().describe("Filter to relationships of a specific entity type"),
    limit: z.number().int().min(1).max(100).optional().default(50).describe("Max results"),
    offset: z.number().int().min(0).optional().default(0).describe("Skip N results"),
  },
  async (args) => {
    const db = initDB()
    try {
      const rels = findIllustrations(db, args)
      const text = formatIllustrationPairs(rels)
      return { content: [{ type: "text" as const, text }] }
    } finally {
      db.close()
    }
  }
)

const transport = new StdioServerTransport()
await server.connect(transport)
