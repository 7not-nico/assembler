#!/usr/bin/env -S bun run
// @toolclass RECG
// Semantic engine stats — per-table counts, model distribution, dimension check.
// Usage: bun run .opencode/tools/semantic-stats.ts [--type TABLE]
// import.meta.main guard: zero side effects at discovery-import.

import { Database } from "bun:sqlite"
import { Store } from "../_lib/paths"
import { cli } from "../_lib/cli"

function main() {
  const { value } = cli(process.argv.slice(2))
  const type = value("--type")

  const store = new Database(Store)

  const where = type ? " WHERE entity_type = ?" : ""
  const param = type ? [type] : []

  const row = store.query(
    `SELECT entity_type, COUNT(*) AS count, COUNT(DISTINCT model_version) AS models,
            MIN((length(vector) / 4)) AS min_dim, MAX((length(vector) / 4)) AS max_dim
     FROM embeddings${where}
     GROUP BY entity_type ORDER BY count DESC`
  ).all(...param) as { entity_type: string; count: number; models: number; min_dim: number; max_dim: number }[]

  if (row.length === 0) {
    console.log("no embeddings found")
    process.exit(0)
  }

  console.log(`${"TABLE".padEnd(20)} ${"COUNT".padStart(6)} ${"MODELS".padStart(7)} ${"DIM".padStart(7)}`)
  console.log("-".repeat(44))
  let total = 0
  for (let line of row) {
    total += line.count
    console.log(`${line.entity_type.padEnd(20)} ${String(line.count).padStart(6)} ${String(line.models).padStart(7)} ${String(line.min_dim === line.max_dim ? line.min_dim : `${line.min_dim}-${line.max_dim}`).padStart(7)}`)
  }
  console.log("-".repeat(44))
  console.log(`TOTAL: ${total} embeddings`)

  if (!type) {
    const model = store.query("SELECT DISTINCT model_version FROM embeddings WHERE model_version IS NOT NULL").all() as { model_version: string }[]
    console.log("\nModels:")
    for (let entry of model) console.log(`  ${entry.model_version}`)
  }

  store.close()
}

if (import.meta.main) {
  main()
}
