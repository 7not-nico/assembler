// @toolclass TRNS
// exports: default
// purity: io
// depends-on: _lib/paths, _lib/embed, _lib/errors, bun:sqlite

import { tool } from "@opencode-ai/plugin"
import { crash } from "../_lib/errors"
import { batch, Model } from "../_lib/embed"
import { Database } from "bun:sqlite"
import { Root } from "../_lib/paths"
import { join } from "path"

const Internal = new Set([
  "embeddings", "fts_entities", "entities_fts",
  "meta", "notes", "sqlite_sequence",
])

// Metadata columns never embedded; remaining first-row keys form the text set.
const Meta = new Set(["id", "source", "tags", "status", "reference", "type", "created", "modified", "enforcement", "priority"])

const hash = (text: string): string =>
  new Bun.CryptoHasher("sha256").update(text).digest("hex")

export default tool({
  description: "Generate embeddings for patlib entities and store in vector DB",
  args: {
    type: tool.schema.string().optional().describe("Entity type (table name) to embed"),
    force: tool.schema.boolean().optional().default(false).describe("Re-embed existing entries"),
  },
  async execute(args) {
    crash()
    let core = new Database(join(Root, ".opencode", "patlib.db"))

    let store = new Database(join(Root, ".opencode", "patlib-vector.db"))
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
    let skip = Array.from(Internal).map(n => `'${n}'`).join(",")
    let table = core.query(
      `SELECT name FROM sqlite_master
       WHERE type='table'
         AND sql LIKE '%id TEXT%'
         AND sql LIKE '%title TEXT%'
         AND name NOT IN (${skip})`
    ).all() as { name: string }[]

    if (args.type) {
      table = table.filter(item => item.name === args.type)
    }

    if (table.length === 0) {
      return "no entity tables found in patlib.db"
    }

    let total = 0

    for (let item of table) {
      // Text columns from first-row keys (no pragma_table_info)
      let sample = core.query(`SELECT * FROM "${item.name}" LIMIT 1`).get() as Record<string, unknown> | null
      if (!sample) continue
      let col = Object.keys(sample).filter(c => !Meta.has(c))

      if (col.length === 0) continue

      let sql = `SELECT id, ${col.map(c => `"${c}"`).join(", ")} FROM "${item.name}"`
      let row = core.query(sql).all() as Record<string, string>[]

      if (row.length === 0) continue

      let list: { id: string; text: string }[] = []
      for (let line of row) {
        if (!line.id) continue

        let record = store.query("SELECT 1 FROM embeddings WHERE entity_id = ? AND entity_type = ?").get(line.id, item.name)
        if (record && !args.force) continue

        let part = [line.id + ": " + (line.title || "")]
        for (let key of col) {
          if (key !== "title" && line[key]) {
            let value = String(line[key]).trim()
            if (value.length > 0) part.push(value.slice(0, 2000))
          }
        }
        list.push({ id: line.id, text: part.join(". ") })
      }

      if (list.length === 0) continue

      let text = list.map(i => i.text)
      let vec: Float32Array[]
      try {
        vec = await batch(text)
      } catch (err: any) {
        return `embed error for ${item.name}: ${err.message}`
      }

      let upsert = store.prepare(
        `INSERT INTO embeddings (entity_type, entity_id, seq, field, vector, content_hash, model_version, updated)
         VALUES (?, ?, 0, 'full', ?, ?, ?, datetime('now'))
         ON CONFLICT(entity_type, entity_id, seq, field) DO UPDATE SET
           vector = excluded.vector,
           content_hash = excluded.content_hash,
           model_version = excluded.model_version,
           updated = excluded.updated`
      )
      for (let index = 0; index < list.length; index++) {
        let blob = Buffer.from(vec[index].buffer)
        upsert.run(item.name, list[index].id, blob, hash(list[index].text), Model)
      }
      total += list.length
    }

    core.close()
    store.close()
    return `embedded ${total} entities${args.type ? " of type '" + args.type + "'" : ""}`
  },
})
