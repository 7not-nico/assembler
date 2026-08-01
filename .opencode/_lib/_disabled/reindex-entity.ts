// exports: reindexEntityType, type EmbedBatchFn, type HashFn, type ModelFn
// purity: io (DB writes, depends on read-entities, vector-query, entity-paths, bun:sqlite)
// depends-on: read-entities, vector-query, entity-paths, bun:sqlite

import type { Database } from "bun:sqlite"
import { readEntityTexts } from "./read-entities"
import { entityTable } from "./vector-query"
import { entityMtime as defaultMtimeFn, entitySourcePath } from "./entity-paths"

export type EmbedBatchFn = (texts: string[]) => Promise<Float32Array[]>
export type HashFn = (text: string) => Promise<string>
export type ModelFn = () => string

export interface ReindexOptions {
  force?: boolean
  scopes?: readonly string[]
  batchSize?: number
  useMtime?: boolean
}

export interface ReindexResult {
  inserted: number
  skipped: number
  total: number
}

const DEFAULT_SCOPES = ["full", "meta", "body"] as const
const DEFAULT_BATCH_SIZE = 32

export async function reindexEntityType(
  patlib: Database,
  vdb: Database,
  entityType: string,
  embedBatch: EmbedBatchFn,
  computeHash: HashFn,
  getModel: ModelFn,
  options: ReindexOptions = {},
): Promise<ReindexResult> {
  const table = entityTable(entityType)
  if (!table) return { inserted: 0, skipped: 0, total: 0 }

  const items = await readEntityTexts(patlib, entityType)
  if (items.length === 0) return { inserted: 0, skipped: 0, total: 0 }

  const scopes = (options.scopes ?? DEFAULT_SCOPES) as readonly string[]
  const batchSize = options.batchSize ?? DEFAULT_BATCH_SIZE
  const force = options.force ?? false
  const useMtime = options.useMtime ?? false

  const insertStmt = vdb.prepare(
    "INSERT OR REPLACE INTO embeddings(entity_type, entity_id, seq, field, vector, content_hash, model_version, source_file, source_mtime, updated) VALUES (?, ?, 0, ?, ?, ?, ?, ?, ?, datetime('now'))"
  )
  const checkStmt = vdb.prepare(
    "SELECT source_mtime FROM embeddings WHERE entity_type = ? AND entity_id = ? AND seq = 0 AND field = ?"
  )
  const ftsInsertStmt = vdb.prepare(
    "INSERT INTO fts_entities(entity_type, entity_id, field, content) VALUES (?, ?, ?, ?)"
  )
  const ftsDeleteStmt = vdb.prepare(
    "DELETE FROM fts_entities WHERE entity_type = ? AND entity_id = ? AND field = ?"
  )

  let inserted = 0
  let skipped = 0

  for (const scope of scopes) {
    const embedKey = `embedText${scope[0].toUpperCase()}${scope.slice(1)}` as "embedTextFull" | "embedTextMeta" | "embedTextBody"
    const ftsKey = `ftsText${scope[0].toUpperCase()}${scope.slice(1)}` as "ftsTextFull" | "ftsTextMeta" | "ftsTextBody"

    const toEmbed: Array<{ item: typeof items[0]; srcPath: string | null; mtime: string | null }> = []

    for (const item of items) {
      if (force) {
        toEmbed.push({ item, srcPath: null, mtime: null })
        continue
      }

      const existing = checkStmt.get(entityType, item.id, scope) as Record<string, unknown> | null

      if (useMtime) {
        const currentMtime = defaultMtimeFn(entityType, item.id)
        if (existing && existing.source_mtime === currentMtime) {
          skipped++
          continue
        }
        const paths = entitySourcePath(entityType, item.id)
        toEmbed.push({ item, srcPath: paths.length > 0 ? paths[0] : null, mtime: currentMtime })
      } else {
        if (existing && existing.source_mtime !== null) {
          skipped++
          continue
        }
        toEmbed.push({ item, srcPath: null, mtime: null })
      }
    }

    if (toEmbed.length === 0) continue

    const mv = getModel()

    for (let i = 0; i < toEmbed.length; i += batchSize) {
      const batch = toEmbed.slice(i, i + batchSize)
      const texts = batch.map(b => b.item[embedKey])
      const vecs = await embedBatch(texts)

      for (let j = 0; j < batch.length; j++) {
        const blob = Buffer.from(vecs[j].buffer)
        const hash = await computeHash(batch[j].item[embedKey])
        insertStmt.run(entityType, batch[j].item.id, scope, blob, hash, mv, batch[j].srcPath, batch[j].mtime)
        ftsDeleteStmt.run(entityType, batch[j].item.id, scope)
        ftsInsertStmt.run(entityType, batch[j].item.id, scope, batch[j].item[ftsKey] || "")
        inserted++
      }
    }
  }

  vdb.exec("INSERT INTO entities_fts(entities_fts) VALUES('rebuild')")

  const validIds = (patlib.query(`SELECT id FROM "${table}"`).all() as Array<Record<string, unknown>>).map(r => String(r.id))
  if (validIds.length > 0) {
    const ph = validIds.map(() => "?").join(",")
    vdb.run(`DELETE FROM embeddings WHERE entity_type = ? AND entity_id NOT IN (${ph})`, entityType, ...validIds)
    vdb.run(`DELETE FROM fts_entities WHERE entity_type = ? AND entity_id NOT IN (${ph})`, entityType, ...validIds)
  } else {
    vdb.run("DELETE FROM embeddings WHERE entity_type = ?", entityType)
    vdb.run("DELETE FROM fts_entities WHERE entity_type = ?", entityType)
  }

  return { inserted, skipped, total: items.length * scopes.length }
}
