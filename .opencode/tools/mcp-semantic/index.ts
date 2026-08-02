#!/usr/bin/env bun
// exports: (none — CLI entrypoint)
// purity: io
// depends-on: semantic-query, semantic-format, @modelcontextprotocol/sdk, zod

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { search, stats, drift, purgeStale, embedEntities, evalMetrics } from "../../_lib/semantic-query"
import { formatSearch, formatStats, formatDrift, formatPurge, formatEmbed, formatEval } from "../../_lib/semantic-format"

const server = new McpServer({ name: "semantic", version: "1.0.0" })

server.tool(
  "semantic_search",
  "Semantic search over patlib entities — embed the query text and return ANN top-k matches with titles across the vector store.",
  {
    query: z.string().min(1).max(300).describe("Natural-language query text"),
    k: z.number().int().min(1).max(50).optional().default(10).describe("Max results"),
    type: z.string().optional().describe("Entity type filter — rules, protocols, terms, concepts, skills, illustrations, etc."),
  },
  async (args) => {
    const { hits, indexed } = await search(args.query, args.k, args.type)
    return { content: [{ type: "text" as const, text: formatSearch(hits, args.query, indexed) }] }
  }
)

server.tool(
  "semantic_stats",
  "Embedding counts per entity table in the vector store.",
  {
    type: z.string().optional().describe("Entity type filter"),
  },
  async (args) => {
    const { rows, total } = stats(args.type)
    return { content: [{ type: "text" as const, text: formatStats(rows, total) }] }
  }
)

server.tool(
  "semantic_drift",
  "Compare patlib.db entity rows against the vector store — reports MISSING (db row without embedding) and STALE (embedding without db row) per table.",
  {
    type: z.string().optional().describe("Entity type filter"),
  },
  async (args) => {
    const report = drift(args.type)
    return { content: [{ type: "text" as const, text: formatDrift(report, report.lines.length) }] }
  }
)

server.tool(
  "semantic_embed",
  "Embed patlib entities into the vector store (upsert). Full run re-embeds all tables and takes about a minute; scope with type to bound it.",
  {
    type: z.string().optional().describe("Entity type to embed — omit for all tables"),
    force: z.boolean().optional().default(false).describe("Re-embed existing rows"),
  },
  async (args) => {
    const { summaries, total } = await embedEntities(args.type, args.force)
    return { content: [{ type: "text" as const, text: formatEmbed(summaries, total) }] }
  }
)

server.tool(
  "semantic_purge",
  "Delete vector-store rows whose entity no longer exists in patlib.db. Dry-run by default; set apply=true to delete.",
  {
    type: z.string().optional().describe("Entity type filter"),
    apply: z.boolean().optional().default(false).describe("Perform the delete"),
  },
  async (args) => {
    const report = purgeStale(args.type, args.apply)
    return { content: [{ type: "text" as const, text: formatPurge(report) }] }
  }
)

server.tool(
  "semantic_eval",
  "Quality metrics over related-ID pairs — MRR, Recall, Precision, Hit, NDCG. Default stored documents is fast; body re-embeds content columns (bounded batch).",
  {
    k: z.number().int().min(1).max(50).optional().default(10).describe("Rank cutoff"),
    variant: z.enum(["default", "raw", "passage"] as const).optional().default("default").describe("Query embedding variant"),
    documents: z.enum(["stored", "title", "body"] as const).optional().default("stored").describe("Document embedding source"),
  },
  async (args) => {
    const { variant, documents, overall, byType } = await evalMetrics(args.k, args.variant, args.documents)
    return { content: [{ type: "text" as const, text: formatEval(variant, documents, args.k, overall, byType) }] }
  }
)

await server.connect(new StdioServerTransport())
