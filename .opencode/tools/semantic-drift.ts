#!/usr/bin/env -S bun run
// @toolclass RECG
// Semantic index drift detector — compares patlib.db entity tables against patlib-vector.db embeddings.
// Reports MISSING (DB row without embedding) and STALE (embedding without DB row) per table.
// Usage: bun run .opencode/tools/semantic-drift.ts [--type TABLE] [--check]

import { Database } from "bun:sqlite"
import { Database as Core, Store } from "../_lib/paths"
import { cli } from "../_lib/cli"

const Internal = new Set([
  "embeddings", "fts_entities", "entities_fts",
  "meta", "notes", "sqlite_sequence",
])

function main() {
  const { value, flag } = cli(process.argv.slice(2))
  const type = value("--type")
  const check = flag("--check")

  const core = new Database(Core)
  const store = new Database(Store)

  // Discover entity tables dynamically — same heuristic as semantic-embed.ts
  const skip = Array.from(Internal).map(n => `'${n}'`).join(",")
  let table = core.query(
    `SELECT name FROM sqlite_master
     WHERE type='table'
       AND sql LIKE '%id TEXT%'
       AND sql LIKE '%title TEXT%'
       AND name NOT IN (${skip})`
  ).all() as { name: string }[]

  if (type) table = table.filter(item => item.name === type)
  table.sort()

  const miss: { table: string; id: string }[] = []
  const ghost: { table: string; id: string }[] = []
  let drift = false

  console.log(`${"TABLE".padEnd(18)} ${"DB".padStart(4)} ${"VEC".padStart(4)} ${"MISS".padStart(4)} ${"STALE".padStart(5)}`)
  console.log("-".repeat(40))

  for (const item of table) {
    const source = new Set(
      (core.query(`SELECT id FROM "${item.name}"`).all() as { id: string }[]).map(row => row.id)
    )
    const index = new Set(
      (store.query("SELECT entity_id FROM embeddings WHERE entity_type = ?").all(item.name) as { entity_id: string }[]).map(row => row.entity_id)
    )

    const missing = [...source].filter(id => !index.has(id)).sort()
    const stale = [...index].filter(id => !source.has(id)).sort()

    for (const id of missing) miss.push({ table: item.name, id })
    for (const id of stale) ghost.push({ table: item.name, id })

    if (missing.length > 0 || stale.length > 0) drift = true

    console.log(`${item.name.padEnd(18)} ${String(source.size).padStart(4)} ${String(index.size).padStart(4)} ${String(missing.length).padStart(4)} ${String(stale.length).padStart(5)}`)
  }

  console.log("-".repeat(40))
  console.log(`TOTAL: ${miss.length} missing, ${ghost.length} stale across ${table.length} tables`)

  if (miss.length > 0) {
    console.log("\nMISSING (in patlib.db, absent from vector store):")
    for (const item of miss) console.log(`  ${item.table.padEnd(14)} ${item.id}`)
  }

  if (ghost.length > 0) {
    console.log("\nSTALE (in vector store, absent from patlib.db):")
    for (const item of ghost) console.log(`  ${item.table.padEnd(14)} ${item.id}`)
  }

  if (check && drift) {
    console.log("\ndrift detected")
    process.exit(1)
  }

  core.close()
  store.close()
  if (check && !drift) console.log("no drift")
}

// Direct execution only — module import (session-start discovery) has zero side effects.
if (import.meta.main) {
  main()
}
