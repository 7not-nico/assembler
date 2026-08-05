#!/usr/bin/env bun
// stress.ts — stress test the templates semantic engine
// Usage: bun run script/stress.ts [--queries N] [--field content]
// Covers: volume, correctness distribution, edge cases, robustness, timing
import { Database } from "bun:sqlite"
import { vector } from "../../../.opencode/_lib/embed.ts"
import { hit } from "../../../.opencode/_lib/score.ts"
import * as path from "node:path"
import { DB_PATH } from "./deps/paths.ts"

const N = parseInt(process.argv.find(a => a.startsWith("--queries="))?.split("=")[1] || "30", 10)
const FIELD = process.argv.find(a => a.startsWith("--field="))?.split("=")[1] || "content"

const db = new Database(DB_PATH, { readonly: true })
const rows = db.query(`SELECT entity_id, field, vector, source_file FROM embeddings WHERE field = ?`).all(FIELD) as { entity_id: string; vector: Uint8Array; source_file: string }[]
const vectors: Float32Array[] = rows.map(r => new Float32Array(r.vector.buffer.slice(r.vector.byteOffset, r.vector.byteOffset + r.vector.byteLength)))

// Query pool — mixed: direct (should hit a known template), topical, adversarial
const POOL = [
  "how do I write a note", "naming convention for precept", "playwright browse pages",
  "browser automation snapshot", "ruby sqlite push script", "keyboard shortcut file",
  "session report entries", "bootstrap new knowledge project", "copy skills to docs",
  "semantic search query", "embed vectors", "anchor workflow skills",
  "practice exercises drills", "glossary term definition", "reference citations verbatim",
  "research capture evidence", "concept decomposition grounding", "bitacora walkthrough",
  "schema sql registry", "fixtures config examples", "format template structure",
  "scaffold knowledge chain", "write report always", "naming conventions rules",
  "cookie recipe", "quantum physics", "how to cook pasta", "bird migration patterns",
  "", "a", "the quick brown fox jumps over the lazy dog", "X", "!!!",
  "semantic semantic semantic semantic semantic", "bun bun bun bun",
]
const pool = POOL.slice(0, N)

let t0 = performance.now()
console.log(`stress: ${pool.length} queries, field=${FIELD}, ${vectors.length} vectors\n`)

// 1. Correctness: top-1 must always be a real entity with score > 0
let real = 0, zero = 0
// 2. Distribution: how many distinct entities appear as top-1 (diversity)
const topCount = new Map<string, number>()
// 3. Timing
let totalMs = 0

for (const q of pool) {
  const start = performance.now()
  let qv: Float32Array
  try {
    qv = await vector(q || "unknown")
  } catch {
    console.log(`  ERR  embed failed for: "${q}"`)
    continue
  }
  const top = hit(qv, vectors, 3)
  totalMs += performance.now() - start
  if (top.length === 0 || top[0].score <= 0) { zero++; continue }
  real++
  const id = rows[top[0].index].entity_id
  topCount.set(id, (topCount.get(id) || 0) + 1)
  if (pool.length <= 40) {
    console.log(`  ${(top[0].score * 100).toFixed(1).padStart(5)}%  ${id.padEnd(32)} ← "${q.slice(0, 44)}"`)
  }
}

const elapsed = performance.now() - t0
console.log(`\n=== results ===`)
console.log(`queries:        ${pool.length}`)
console.log(`embedded ok:    ${real}`)
console.log(`zero-score:     ${zero}`)
console.log(`distinct top-1: ${topCount.size} entities`)
console.log(`avg per query:  ${(totalMs / pool.length).toFixed(1)}ms`)
console.log(`total:          ${elapsed.toFixed(0)}ms`)
console.log(`top entities:   ${[...topCount.entries()].sort((a,b)=>b[1]-a[1]).slice(0,6).map(([k,v])=>`${k}×${v}`).join(", ")}`)

// 4. Robustness: malformed inputs
console.log(`\n=== robustness ===`)
for (const bad of [undefined, " ", "—", "''", "SELECT * FROM embeddings", "日本語テキスト"]) {
  try {
    const qv = await vector(bad ?? "")
    const top = hit(qv, vectors, 5)
    console.log(`  ok   "${String(bad).slice(0, 24)}" → ${top.length} results`)
  } catch (e) {
    console.log(`  FAIL "${String(bad).slice(0, 24)}" → ${(e as Error).message.slice(0, 60)}`)
  }
}
