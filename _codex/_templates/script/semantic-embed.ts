#!/usr/bin/env bun
// semantic-embed.ts — embed _templates/ artifacts into templates-vector.db
// CLI tool (Bun). Usage: bun run script/semantic-embed.ts [--force]
// Stores: embeddings(entity_id, field, vector, content_hash, model_version, source_file, source_mtime, updated)
import { Database } from "bun:sqlite"
import { vector } from "../../../.opencode/_lib/embed.ts"
import { createHash } from "node:crypto"
import * as fs from "node:fs"
import * as path from "node:path"

const ROOT = path.resolve(import.meta.dir, "..")
const MODEL = "Xenova/bge-small-en-v1.5"
const DIM = 384
const DB_PATH = path.join(ROOT, "schema", "templates-vector.db")
const REG_PATH = path.join(ROOT, "schema", "templates.db")
const FORCE = process.argv.includes("--force")

const db = new Database(DB_PATH)
const reg = new Database(REG_PATH, { readonly: true })
db.exec(`
CREATE TABLE IF NOT EXISTS embeddings (
  entity_id     TEXT NOT NULL,
  field         TEXT NOT NULL,
  vector        BLOB NOT NULL,
  content_hash  TEXT NOT NULL,
  model_version TEXT NOT NULL,
  source_file   TEXT NOT NULL,
  source_mtime  TEXT NOT NULL,
  updated       TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (entity_id, field)
);
CREATE VIRTUAL TABLE IF NOT EXISTS fts USING fts5(entity_id, field, text);`)

let pipe: any = null
async function vec(text: string): Promise<Float32Array> {
  return vector(text)
}

// Collect artifacts: templates (name, layer, purpose) + reports (project, errors, findings)
function collect(): { id: string; field: string; text: string; file: string }[] {
  const items: { id: string; field: string; text: string; file: string }[] = []
  for (const f of fs.readdirSync(ROOT).filter(f => f.endsWith("-template.md"))) {
    const content = fs.readFileSync(path.join(ROOT, f), "utf8")
    const layer = (content.match(/\*\*Layer:\*\*\s*(.+)/)?.[1]?.trim() || "bootstrap").split(" ")[0]
    const purpose = content.match(/\*\*Purpose:\*\*\s*(.+)/)?.[1]?.trim() || ""
    // tags + composes from registry rows — discriminative metadata feeds the vector
    let meta = ""
    const row = reg.query(`SELECT tags, composes, chain_pos FROM templates WHERE id = ?`).get(f) as any
    if (row) {
      const tags = JSON.parse(row.tags || "[]") as string[]
      const composes = JSON.parse(row.composes || "[]") as string[]
      meta = `TAGS: ${tags.join(", ")}\nCOMPOSES: ${composes.join(", ")}\nCHAIN: ${row.chain_pos ?? "infra"}\n\n`
    }
    // content field: raw file text (no prefix — prefix test regressed accuracy)
    items.push({ id: f, field: "content", text: content, file: f })
    items.push({ id: f, field: "purpose", text: purpose, file: f })
    if (meta) items.push({ id: f, field: "meta", text: meta, file: f })
  }
  const infDir = path.join(ROOT, "reports")
  if (fs.existsSync(infDir)) {
    for (const f of fs.readdirSync(infDir).filter(f => f.endsWith(".md") && f !== "report-template.md")) {
      const content = fs.readFileSync(path.join(infDir, f), "utf8")
      items.push({ id: f, field: "content", text: content, file: path.join("reports", f) })
    }
  }
  return items
}

const items = collect()
let done = 0, skipped = 0
for (const it of items) {
  const fp = path.join(ROOT, it.file)
  const mtime = fs.statSync(fp).mtimeMs.toString()
  const hash = createHash("sha256").update(it.text).digest("hex")

  const existing = db.query(`SELECT content_hash, source_mtime FROM embeddings WHERE entity_id = ? AND field = ?`).get(it.id, it.field) as any
  if (!FORCE && existing && existing.content_hash === hash && existing.source_mtime === mtime) {
    skipped++
    continue
  }

  const vecV = await vec(it.text)
  db.query(`INSERT INTO embeddings (entity_id, field, vector, content_hash, model_version, source_file, source_mtime)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(entity_id, field) DO UPDATE SET vector=excluded.vector,
              content_hash=excluded.content_hash, model_version=excluded.model_version,
              source_file=excluded.source_file, source_mtime=excluded.source_mtime,
              updated=datetime('now')`)
    .run(it.id, it.field, Buffer.from(vecV.buffer), hash, MODEL, it.file, mtime)
  // FTS5 mirror — replace row for this entity+field (keyword search companion)
  db.query(`DELETE FROM fts WHERE entity_id = ? AND field = ?`).run(it.id, it.field)
  db.query(`INSERT INTO fts (entity_id, field, text) VALUES (?, ?, ?)`).run(it.id, it.field, it.text)
  done++
}
console.log(`embedded ${done} (skipped ${skipped} unchanged) → ${DB_PATH}`)
