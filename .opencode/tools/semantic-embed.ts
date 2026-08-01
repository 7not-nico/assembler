#!/usr/bin/env -S bun run
// @toolclass TRNS
// Embed patlib entities into patlib-vector.db (real schema: content_hash, model_version).
// Usage: bun run .opencode/tools/semantic-embed.ts [--type TABLE] [--force]
// import.meta.main guard: zero side effects at discovery-import.

import { Database } from "bun:sqlite"
import { batch, Model } from "../_lib/embed"
import { Database as Core, Store } from "../_lib/paths"
import { cli } from "../_lib/cli"

const Internal = new Set([
  "embeddings", "fts_entities", "entities_fts",
  "meta", "notes", "sqlite_sequence",
])

// Metadata columns never embedded; remaining first-row keys form the text set.
const Meta = new Set(["id", "source", "tags", "status", "reference", "type", "created", "modified", "enforcement", "priority"])

const hash = (text: string): string =>
  new Bun.CryptoHasher("sha256").update(text).digest("hex")

async function main() {
  const { value, flag } = cli(process.argv.slice(2))
  const type = value("--type")
  const force = flag("--force")

  const core = new Database(Core)
  const store = new Database(Store)
  store.exec(`CREATE TABLE IF NOT EXISTS embeddings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    seq INTEGER NOT NULL DEFAULT 0,
    field TEXT NOT NULL DEFAULT 'full',
    vector BLOB NOT NULL,
    content_hash TEXT NOT NULL,
    model_version TEXT,
    source_file TEXT,
    source_mtime TEXT,
    updated TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE(entity_type, entity_id, seq, field)
  )`)
  store.exec(`CREATE INDEX IF NOT EXISTS idx_embeddings_lookup
    ON embeddings(entity_type, entity_id, seq, field)`)

  // Discover entity tables dynamically from schema
  const skip = Array.from(Internal).map(n => `'${n}'`).join(",")
  let table = core.query(
    `SELECT name FROM sqlite_master
     WHERE type='table'
       AND sql LIKE '%id TEXT%'
       AND sql LIKE '%title TEXT%'
       AND name NOT IN (${skip})`
  ).all() as { name: string }[]

  if (type) table = table.filter(item => item.name === type)

  if (table.length === 0) {
    console.error("no entity tables found in patlib.db")
    process.exit(1)
  }

  let total = 0

  for (let item of table) {
    // Text columns from first-row keys (no pragma_table_info)
    const sample = core.query(`SELECT * FROM "${item.name}" LIMIT 1`).get() as Record<string, unknown> | null
    if (!sample) continue
    const col = Object.keys(sample).filter(c => !Meta.has(c))

    if (col.length === 0) continue

    const sql = `SELECT id, ${col.map(c => `"${c}"`).join(", ")} FROM "${item.name}"`
    const row = core.query(sql).all() as Record<string, string>[]
    if (row.length === 0) continue

    const list: { id: string; text: string }[] = []
    for (let line of row) {
      if (!line.id) continue

      const record = store.query(
        "SELECT 1 FROM embeddings WHERE entity_type = ? AND entity_id = ? AND seq = 0 AND field = 'full'"
      ).get(item.name, line.id)
      if (record && !force) continue

      const part = [line.id + ": " + (line.title || "")]
      for (let key of col) {
        if (key !== "title" && line[key]) {
          const value = String(line[key]).trim()
          if (value.length > 0) part.push(value.slice(0, 2000))
        }
      }
      list.push({ id: line.id, text: part.join(". ") })
    }

    if (list.length === 0) continue

    let vec: Float32Array[]
    try {
      vec = await batch(list.map(i => i.text))
    } catch (err: any) {
      console.error(`embed error for ${item.name}: ${err.message}`)
      process.exit(1)
    }

    const upsert = store.prepare(
      `INSERT INTO embeddings (entity_type, entity_id, seq, field, vector, content_hash, model_version, updated)
       VALUES (?, ?, 0, 'full', ?, ?, ?, datetime('now'))
       ON CONFLICT(entity_type, entity_id, seq, field) DO UPDATE SET
         vector = excluded.vector,
         content_hash = excluded.content_hash,
         model_version = excluded.model_version,
         updated = excluded.updated`
    )
    for (let index = 0; index < list.length; index++) {
      const blob = Buffer.from(vec[index].buffer)
      upsert.run(item.name, list[index].id, blob, hash(list[index].text), Model)
    }
    total += list.length
    console.log(`embedded ${list.length} ${item.name}`)
  }

  core.close()
  store.close()
  console.log(`\n${total} entities embedded${type ? ` of type '${type}'` : ""}${force ? " (force)" : ""}`)
}

if (import.meta.main) {
  main()
}
