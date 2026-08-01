#!/usr/bin/env -S bun run
// @toolclass TRNS
// Stale embedding purge — deletes vector-store rows whose entity no longer exists in patlib.db.
// Read-only by default (reports count); --apply performs the delete.
// Usage: bun run .opencode/tools/semantic-purge.ts [--type TABLE] [--apply]

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
  const apply = flag("--apply")

  const core = new Database(Core)
  const store = new Database(Store)

  const skip = Array.from(Internal).map(n => `'${n}'`).join(",")
  const table = (core.query(
    `SELECT name FROM sqlite_master
     WHERE type='table'
       AND sql LIKE '%id TEXT%'
       AND sql LIKE '%title TEXT%'
       AND name NOT IN (${skip})`
  ).all() as { name: string }[])
    .map(item => item.name)
    .filter(item => !type || item === type)
    .sort()

  let stale = 0
  const sample: string[] = []

  for (const item of table) {
    const source = new Set(
      (core.query(`SELECT id FROM "${item}"`).all() as { id: string }[]).map(entry => entry.id)
    )
    const row = store.query(
      "SELECT id, entity_id FROM embeddings WHERE entity_type = ?"
    ).all(item) as { id: number; entity_id: string }[]

    for (const line of row) {
      if (source.has(line.entity_id)) continue
      stale++
      if (sample.length < 20) sample.push(`${item}/${line.entity_id}`)
      if (apply) store.query("DELETE FROM embeddings WHERE id = ?").run(line.id)
    }
  }

  console.log(`${stale} stale embeddings${type ? ` of type '${type}'` : ""}${apply ? " purged" : " found (dry-run — use --apply to purge)"}`)
  for (const entry of sample) console.log(`  ${entry}`)

  core.close()
  store.close()
}

// Direct execution only — module import (session-start discovery) has zero side effects.
if (import.meta.main) {
  main()
}
