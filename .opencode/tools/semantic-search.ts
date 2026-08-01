#!/usr/bin/env -S bun run
// @toolclass RECG
// Semantic search over patlib entities — query → embedding → Rust ANN top-k (shared endpoint) → titles.
// Usage: bun run .opencode/tools/semantic-search.ts --query TEXT [--k N] [--type TABLE]

import { Database } from "bun:sqlite"
import { query as embedQuery } from "../_lib/embed"
import { Database as Core, Store } from "../_lib/paths"
import { cli } from "../_lib/cli"
import { hit } from "../_lib/ann"

async function main() {
  const { value } = cli(process.argv.slice(2))
  const query = value("--query")
  const k = Number(value("--k") || "10")
  const type = value("--type")

  if (!query) {
    console.error("Usage: semantic-search --query TEXT [--k N] [--type TABLE]")
    process.exit(1)
  }

  // 1. Query embedding
  let vec: Float32Array
  try {
    vec = await embedQuery(query)
  } catch (e: any) {
    console.error(`embed error: ${e.message}`)
    process.exit(1)
  }

  // 2. Read stored vectors
  const store = new Database(Store)
  const filter = type ? " WHERE entity_type = ?" : ""
  const row = store.query(
    `SELECT entity_id, entity_type, vector FROM embeddings${filter} ORDER BY id`
  ).all(type || undefined) as { entity_id: string; entity_type: string; vector: Buffer }[]

  if (row.length === 0) {
    console.error("no embeddings found. run semantic-embed first.")
    process.exit(1)
  }

  const entry: { id: string; type: string }[] = []
  const pool: Float32Array[] = []
  for (let sample of row) {
    entry.push({ id: sample.entity_id, type: sample.entity_type })
    pool.push(new Float32Array(sample.vector.buffer, sample.vector.byteOffset, sample.vector.byteLength / 4))
  }

  // 3. Rust ANN top-k via shared endpoint (_lib/ann.ts → assemble hit)
  let rank: { index: number; score: number }[]
  try {
    rank = await hit(vec, pool, k)
  } catch (e: any) {
    console.error(`ann error: ${e.message}`)
    process.exit(1)
  }
  if (rank.length === 0) {
    console.log("no semantic matches found")
    process.exit(0)
  }

  // 4. Join titles from patlib.db
  const core = new Database(Core)
  let total = 0
  console.log("RANK  SCORE    TYPE        ID")
  console.log("-".repeat(70))
  for (let line of rank) {
    const item = entry[line.index]
    if (!item) continue
    const detail = core.query(`SELECT title FROM "${item.type}" WHERE id = ?`).get(item.id) as { title: string } | undefined
    const title = detail?.title || item.id
    console.log(`${String(++total).padEnd(5)} ${line.score.toFixed(4).padEnd(9)} ${item.type.padEnd(12)} ${item.id}`)
    console.log(`       ${title.slice(0, 96)}`)
  }
  core.close()
  store.close()
  console.log("-".repeat(70))
  console.log(`${total} semantic matches for "${query}" (${row.length} indexed)`)
}

// Direct execution only — module import (session-start discovery) has zero side effects.
if (import.meta.main) {
  main()
}
