#!/usr/bin/env bun
// bench.ts — evaluate semantic search across a fixed query suite
// Usage: bun run script/bench.ts [--field content] — prints per-query top-hit + score
// Uses Go ann-tpl batch verb — ONE spawn serves the whole suite (no per-query stall).
import { Database } from "bun:sqlite"
import { vector } from "../../../.opencode/_lib/embed.ts"
import * as path from "node:path"
import * as fs from "node:fs"

const ROOT = path.resolve(import.meta.dir, "..")
const DB_PATH = path.join(ROOT, "schema", "templates-vector.db")
const FIELD = process.argv.find(a => a.startsWith("--field="))?.split("=")[1] || "content"

const SUITE: [string, string[]][] = [
  // [query, acceptable targets] — ambiguous queries accept multiple
  ["where does verbatim source text live", ["reference-template.md", "research-template.md"]],
  ["capture dynamic page content with browser automation", ["browse-playwright-template.md"]],
  ["sharp library failed to load native libvips", ["20260731-004633.md", "20260731-005130.md"]],
  ["hands-on exercise drill validating conventions", ["practice-template.md"]],
  ["write a session report with errors and findings", ["report-template.md"]],
  ["structural format definition governing file shape", ["format-template.md"]],
]

const db = new Database(DB_PATH, { readonly: true })
const rows = db.query(`SELECT entity_id, field, vector FROM embeddings WHERE field = ?`).all(FIELD) as { entity_id: string; vector: Uint8Array }[]
const vectors: Float32Array[] = rows.map(r => new Float32Array(r.vector.buffer.slice(r.vector.byteOffset, r.vector.byteOffset + r.vector.byteLength)))

// Embed all queries first, then ONE Go binary batch call
const queryVecs: Float32Array[] = []
for (const [q] of SUITE) queryVecs.push(await vector(q))

let topIndices: { index: number; score: number }[] = []
try {
  const { batch } = await import("../_lib/ann-tpl.ts")
  const results = await batch(queryVecs, vectors, 3)
  topIndices = results.map(h => h[0])
} catch {
  // fallback: in-process scoring
  const { hit } = await import("../../../.opencode/_lib/score.ts")
  topIndices = queryVecs.map(q => hit(q, vectors, 3)[0])
}

let correct = 0
console.log(`field=${FIELD}  vectors=${vectors.length}  (Go batch ANN)\n`)
for (let i = 0; i < SUITE.length; i++) {
  const [q, accepts] = SUITE[i]
  const top = topIndices[i]
  const topId = rows[top.index].entity_id
  const ok = accepts.includes(topId)
  if (ok) correct++
  console.log(`${ok ? "✓" : "✗"} ${(top.score * 100).toFixed(1).padStart(5)}%  ${topId.padEnd(32)} expected: ${accepts[0]}`)
}
console.log(`\naccuracy: ${correct}/${SUITE.length}`)
