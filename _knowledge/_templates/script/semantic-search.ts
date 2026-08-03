#!/usr/bin/env bun
// semantic-search.ts — hybrid semantic + keyword search over _templates/ vector store
// CLI tool (Bun). Usage: bun run script/semantic-search.ts --query TEXT [--k N] [--field purpose|content]
// Hybrid: semantic cosine (Go ann-tpl heavy scoring; _lib/score.ts fallback) fused with FTS5 keyword rank.
import { Database } from "bun:sqlite"
import { vector } from "../../../.opencode/_lib/embed.ts"
import * as path from "node:path"
import * as fs from "node:fs"

const ROOT = path.resolve(import.meta.dir, "..")
const DB_PATH = path.join(ROOT, "schema", "templates-vector.db")

// ANN backend: default Go binary transport (3.8× faster at scale); --ts forces in-process
// TS; falls back to TS on Go errors.
async function annHit(query: Float32Array, vectors: Float32Array[], k: number): Promise<{ index: number; score: number }[]> {
  if (arg("ts") === undefined) {
    try {
      const { batch } = await import("../_lib/ann-tpl.ts")
      const results = await batch([query], vectors, k)
      return results[0]
    } catch {
      // fall through to in-process scoring
    }
  }
  const { hit } = await import("../../../.opencode/_lib/score.ts")
  return hit(query, vectors, k)
}

function arg(name: string): string | undefined {
  const i = process.argv.indexOf(`--${name}`)
  return i >= 0 ? process.argv[i + 1] : undefined
}
const QUERY = arg("query")
const K = parseInt(arg("k") || "5", 10)
const FIELD = arg("field") || "content"
const ALPHA = parseFloat(arg("alpha") || "0.55") // semantic weight; keyword = 1-alpha

if (!QUERY) {
  console.error("usage: bun run script/semantic-search.ts --query TEXT [--k N] [--field purpose|content] [--alpha 0.55] [--ts]")
  process.exit(1)
}

const db = new Database(DB_PATH, { readonly: true })
const rows = db.query(
  `SELECT entity_id, field, vector, source_file FROM embeddings WHERE field = ?`
).all(FIELD) as { entity_id: string; vector: Uint8Array; source_file: string }[]

if (rows.length === 0) {
  console.log(`no embeddings for field="${FIELD}" — run script/semantic-embed.ts first`)
  process.exit(0)
}

const vectors: Float32Array[] = rows.map(r => new Float32Array(r.vector.buffer.slice(r.vector.byteOffset, r.vector.byteOffset + r.vector.byteLength)))
const queryVec = await vector(QUERY)
const semantic = await annHit(queryVec, vectors, rows.length)

// FTS5 keyword scores — bm25 rank as fraction of top; tokenize query into OR terms
const terms = QUERY.toLowerCase().split(/\s+/).filter(t => t.length > 2 && !["where", "does", "with", "the", "and", "for", "raw", "how"].includes(t))
const ftsQuery = terms.map(t => `"${t.replace(/"/g, '""')}"`).join(" OR ")
const fts = db.query(`SELECT entity_id, field, rank FROM fts WHERE fts MATCH ? AND field = ?`).all(ftsQuery, FIELD) as { entity_id: string; rank: number }[]
const ftsByEntity = new Map<string, number>()
for (const f of fts) ftsByEntity.set(f.entity_id, f.rank)
let ftsMax = 0
for (const v of ftsByEntity.values()) ftsMax = Math.max(ftsMax, Math.abs(v))

// Fuse: semantic score (normalized 0..1) * alpha + keyword rank fraction * (1-alpha)
const fused = semantic.map(s => {
  const entity = rows[s.index].entity_id
  const kw = ftsMax > 0 ? (Math.abs(ftsByEntity.get(entity) ?? 0) / ftsMax) : 0
  return { index: s.index, score: ALPHA * s.score + (1 - ALPHA) * kw, kw }
})
fused.sort((a, b) => b.score - a.score)
const top = fused.slice(0, Math.max(0, Math.min(K, fused.length)))

console.log(`top ${top.length} matches for "${QUERY}" (field=${FIELD}, α=${ALPHA})\n`)
for (const r of top) {
  const row = rows[r.index]
  console.log(`${(r.score * 100).toFixed(1).padStart(5)}%  ${row.entity_id}  [kw ${(r.kw * 100).toFixed(0)}%]`)
}
