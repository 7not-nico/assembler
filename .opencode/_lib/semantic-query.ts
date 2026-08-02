// exports: search, stats, drift, purgeStale, embedEntities, evalMetrics
// purity: io
// depends-on: paths, embed, ann, semantic-types (import type)

import { Database } from "bun:sqlite"
import { Database as Core, Store } from "./paths"
import { query as embedQuery, batch, Model } from "./embed"
import { hit } from "./ann"
import type {
  SearchHit, TableStat, DriftReport, PurgeReport, EmbedSummary,
  EvalOverall, EvalByType,
} from "./semantic-types"

const Internal = new Set(["embeddings", "fts_entities", "entities_fts", "meta", "notes", "sqlite_sequence"])
const Meta = new Set(["id", "source", "tags", "status", "reference", "type", "created", "modified", "enforcement", "priority"])

const hash = (text: string): string =>
  new Bun.CryptoHasher("sha256").update(text).digest("hex")

function discoverTables(core: Database, type?: string): string[] {
  const skip = Array.from(Internal).map(n => `'${n}'`).join(",")
  const table = core.query(
    `SELECT name FROM sqlite_master
     WHERE type='table'
       AND sql LIKE '%id TEXT%'
       AND sql LIKE '%title TEXT%'
       AND name NOT IN (${skip})`
  ).all() as { name: string }[]
  return table.map(t => t.name).filter(t => !type || t === type).sort()
}

// ---- search ----

export async function search(queryText: string, k: number, type?: string): Promise<{ hits: SearchHit[]; indexed: number }> {
  const vec = await embedQuery(queryText)
  const store = new Database(Store)
  try {
    const filter = type ? " WHERE entity_type = ?" : ""
    const rows = store.query(
      `SELECT entity_id, entity_type, vector FROM embeddings${filter} ORDER BY id`
    ).all(type || undefined) as { entity_id: string; entity_type: string; vector: Buffer }[]

    const entries: { id: string; type: string }[] = []
    const pool: Float32Array[] = []
    for (const r of rows) {
      entries.push({ id: r.entity_id, type: r.entity_type })
      pool.push(new Float32Array(r.vector.buffer, r.vector.byteOffset, r.vector.byteLength / 4))
    }
    if (pool.length === 0) return { hits: [], indexed: 0 }

    const rank = await hit(vec, pool, k)
    const core = new Database(Core)
    try {
      const hits: SearchHit[] = []
      for (const line of rank) {
        const item = entries[line.index]
        if (!item) continue
        const detail = core.query(`SELECT title FROM "${item.type}" WHERE id = ?`).get(item.id) as { title: string } | undefined
        hits.push({ rank: hits.length + 1, score: line.score, type: item.type, id: item.id, title: detail?.title || item.id })
      }
      return { hits, indexed: pool.length }
    } finally {
      core.close()
    }
  } finally {
    store.close()
  }
}

// ---- stats ----

export function stats(type?: string): { rows: TableStat[]; total: number } {
  const store = new Database(Store)
  try {
    const where = type ? " WHERE entity_type = ?" : ""
    const param = type ? [type] : []
    const rows = store.query(
      `SELECT entity_type, COUNT(*) AS count, COUNT(DISTINCT model_version) AS models,
              MIN((length(vector) / 4)) AS min_dim, MAX((length(vector) / 4)) AS max_dim
       FROM embeddings${where}
       GROUP BY entity_type ORDER BY count DESC`
    ).all(...param) as { entity_type: string; count: number; models: number; min_dim: number; max_dim: number }[]
    return {
      rows: rows.map(r => ({ table: r.entity_type, count: r.count, models: r.models, dim: r.min_dim })),
      total: rows.reduce((a, r) => a + r.count, 0),
    }
  } finally {
    store.close()
  }
}

// ---- drift ----

export function drift(type?: string): DriftReport {
  const core = new Database(Core)
  const store = new Database(Store)
  try {
    const tables = discoverTables(core, type)
    const lines = []
    let missingTotal = 0
    let staleTotal = 0
    for (const t of tables) {
      const source = new Set(
        (core.query(`SELECT id FROM "${t}"`).all() as { id: string }[]).map(r => r.id)
      )
      const index = new Set(
        (store.query("SELECT entity_id FROM embeddings WHERE entity_type = ?").all(t) as { entity_id: string }[]).map(r => r.entity_id)
      )
      const missing = [...source].filter(id => !index.has(id)).length
      const stale = [...index].filter(id => !source.has(id)).length
      missingTotal += missing
      staleTotal += stale
      lines.push({ table: t, db: source.size, vec: index.size, missing, stale })
    }
    return { lines, missingTotal, staleTotal }
  } finally {
    core.close()
    store.close()
  }
}

// ---- purge ----

export function purgeStale(type?: string, apply = false): PurgeReport {
  const core = new Database(Core)
  const store = new Database(Store)
  try {
    const tables = discoverTables(core, type)
    let staleTotal = 0
    const sample: string[] = []
    for (const t of tables) {
      const source = new Set(
        (core.query(`SELECT id FROM "${t}"`).all() as { id: string }[]).map(r => r.id)
      )
      const rows = store.query("SELECT id, entity_id FROM embeddings WHERE entity_type = ?").all(t) as { id: number; entity_id: string }[]
      for (const line of rows) {
        if (source.has(line.entity_id)) continue
        staleTotal++
        if (sample.length < 20) sample.push(`${t}/${line.entity_id}`)
        if (apply) store.query("DELETE FROM embeddings WHERE id = ?").run(line.id)
      }
    }
    return { staleTotal, sample, applied: apply }
  } finally {
    core.close()
    store.close()
  }
}

// ---- embed ----

export async function embedEntities(type?: string, force = false): Promise<{ summaries: EmbedSummary[]; total: number }> {
  const core = new Database(Core)
  const store = new Database(Store)
  try {
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

    const tables = discoverTables(core, type)
    const summaries: EmbedSummary[] = []
    let total = 0

    for (const t of tables) {
      const sample = core.query(`SELECT * FROM "${t}" LIMIT 1`).get() as Record<string, unknown> | null
      if (!sample) continue
      const col = Object.keys(sample).filter(c => !Meta.has(c))
      if (col.length === 0) continue

      const sql = `SELECT id, ${col.map(c => `"${c}"`).join(", ")} FROM "${t}"`
      const rows = core.query(sql).all() as Record<string, string>[]
      if (rows.length === 0) continue

      const list: { id: string; text: string }[] = []
      for (const line of rows) {
        if (!line.id) continue
        const record = store.query(
          "SELECT 1 FROM embeddings WHERE entity_type = ? AND entity_id = ? AND seq = 0 AND field = 'full'"
        ).get(t, line.id)
        if (record && !force) continue
        const part = [line.id + ": " + (line.title || "")]
        for (const key of col) {
          if (key !== "title" && line[key]) {
            const value = String(line[key]).trim()
            if (value.length > 0) part.push(value.slice(0, 2000))
          }
        }
        list.push({ id: line.id, text: part.join(". ") })
      }
      if (list.length === 0) continue

      const vec = await batch(list.map(i => i.text))
      const upsert = store.prepare(
        `INSERT INTO embeddings (entity_type, entity_id, seq, field, vector, content_hash, model_version, updated)
         VALUES (?, ?, 0, 'full', ?, ?, ?, datetime('now'))
         ON CONFLICT(entity_type, entity_id, seq, field) DO UPDATE SET
           vector = excluded.vector,
           content_hash = excluded.content_hash,
           model_version = excluded.model_version,
           updated = excluded.updated`
      )
      for (let i = 0; i < list.length; i++) {
        upsert.run(t, list[i].id, Buffer.from(vec[i].buffer), hash(list[i].text), Model)
      }
      total += list.length
      summaries.push({ table: t, embedded: list.length })
    }
    return { summaries, total }
  } finally {
    core.close()
    store.close()
  }
}

// ---- eval ----

type Pair = { queryId: string; queryText: string; targets: string[] }

async function embedChunks(
  embed: (texts: string[]) => Promise<Float32Array[]>,
  texts: string[],
  size: number
): Promise<Float32Array[]> {
  const vectors: Float32Array[] = []
  for (let start = 0; start < texts.length; start += size) {
    vectors.push(...await embed(texts.slice(start, start + size)))
  }
  return vectors
}

function dot(a: Float32Array, b: Float32Array): number {
  let s = 0
  for (let i = 0; i < a.length; i++) s += a[i] * b[i]
  return s
}

function topK(query: Float32Array, pool: Float32Array[], k: number): { index: number; score: number }[] {
  const scores = pool.map((v, i) => ({ index: i, score: dot(query, v) }))
  scores.sort((a, b) => b.score - a.score)
  return scores.slice(0, k)
}

function mean(values: number[]): number {
  if (values.length === 0) return 0
  return values.reduce((a, b) => a + b, 0) / values.length
}

async function loadDocuments(): Promise<Record<string, { title: string; body: string }>> {
  const core = new Database(Core)
  try {
    const documents: Record<string, { title: string; body: string }> = {}
    for (const t of discoverTables(core)) {
      const sample = core.query(`SELECT * FROM "${t}" LIMIT 1`).get() as Record<string, unknown> | null
      if (!sample) continue
      const columns = Object.keys(sample).filter(c => !Meta.has(c))
      const rows = core.query(`SELECT * FROM "${t}"`).all() as Record<string, unknown>[]
      for (const row of rows) {
        if (!row.id) continue
        const title = String(row.title || "").trim()
        const parts = [`${row.id}: ${title}`]
        for (const column of columns) {
          if (column === "title" || !row[column]) continue
          const value = String(row[column]).trim()
          if (value) parts.push(value.slice(0, 2000))
        }
        documents[`${t}:${row.id}`] = { title, body: parts.join(". ") }
      }
    }
    return documents
  } finally {
    core.close()
  }
}

export async function evalMetrics(
  k: number,
  variantName: string,
  documentName: string
): Promise<{ variant: string; documents: string; overall: EvalOverall; byType: EvalByType }> {
  // Load related pairs from patlib.db
  const core = new Database(Core)
  const pairs: Pair[] = []
  try {
    for (const t of discoverTables(core)) {
      const sample = core.query(`SELECT * FROM "${t}" LIMIT 1`).get() as Record<string, unknown> | null
      if (!sample) continue
      const related = Object.keys(sample).includes("related") ? `, related` : ""
      const rows = core.query(`SELECT id, title${related} FROM "${t}"`).all() as Record<string, string>[]
      for (const r of rows) {
        if (!r.id) continue
        const targets = (r.related || "").split(",").map(s => s.trim()).filter(Boolean)
        if (targets.length > 0 && r.title) pairs.push({ queryId: r.id, queryText: r.title, targets })
      }
    }
  } finally {
    core.close()
  }

  // Load stored vectors (seq=0, field='full')
  const store = new Database(Store)
  let ids: string[] = []
  let types: string[] = []
  let storedPool: Float32Array[] = []
  try {
    const rows = store.query(
      "SELECT entity_id, entity_type, vector FROM embeddings WHERE seq = 0 AND field = 'full'"
    ).all() as { entity_id: string; entity_type: string; vector: Buffer }[]
    for (const r of rows) {
      ids.push(r.entity_id)
      types.push(r.entity_type)
      storedPool.push(new Float32Array(r.vector.buffer, r.vector.byteOffset, r.vector.byteLength / 4))
    }
  } finally {
    store.close()
  }

  if (pairs.length === 0 || storedPool.length === 0) {
    return { variant: variantName, documents: documentName, overall: { queries: 0, mrrAtK: 0, recallAtK: 0, precisionAtK: 0, hitAtK: 0, ndcgAtK: 0, selfHitAtK: 0 }, byType: {} }
  }

  const variants: Record<string, (texts: string[]) => Promise<Float32Array[]>> = {
    default: (texts) => batch(texts.map(t => `Represent this sentence for searching relevant passages: ${t}`)),
    raw: (texts) => batch(texts),
    passage: (texts) => batch(texts.map(t => `passage: ${t}`)),
  }
  const embed = variants[variantName] || variants.default
  const batchSize = documentName === "body" ? 2 : 16

  const queryVectors = await embedChunks(embed, pairs.map(p => p.queryText), batchSize)
  let pool = storedPool
  if (documentName !== "stored") {
    const documents = await loadDocuments()
    const texts = ids.map((id, i) => {
      const doc = documents[`${types[i]}:${id}`]
      if (!doc) return id
      return documentName === "title" ? doc.title : doc.body
    })
    pool = await embedChunks(batch, texts, batchSize)
  }

  const mrrs: number[] = []
  const recalls: number[] = []
  const precisions: number[] = []
  const hits: number[] = []
  const ndcgs: number[] = []
  const byTypeRaw: Record<string, { mrrs: number[]; recalls: number[]; hits: number[]; ndcgs: number[] }> = {}
  let selfHits = 0

  for (let i = 0; i < pairs.length; i++) {
    const p = pairs[i]
    const top = topK(queryVectors[i], pool, k)
    const topIds = top.map(t => ids[t.index])
    const type = types[ids.indexOf(p.queryId)] || "unknown"
    if (!byTypeRaw[type]) byTypeRaw[type] = { mrrs: [], recalls: [], hits: [], ndcgs: [] }

    let firstRank = 0
    let found = 0
    for (let r = 0; r < topIds.length; r++) {
      if (topIds[r] === p.queryId) selfHits++
      if (p.targets.includes(topIds[r]) && firstRank === 0) firstRank = r + 1
      if (p.targets.includes(topIds[r])) found++
    }

    const mrr = firstRank > 0 ? 1 / firstRank : 0
    const recall = p.targets.length > 0 ? found / p.targets.length : 0
    const precision = found / k
    const hit = found > 0 ? 1 : 0
    let dcg = 0
    for (let r = 0; r < topIds.length; r++) {
      if (p.targets.includes(topIds[r])) dcg += 1 / Math.log2(r + 2)
    }
    let ideal = 0
    for (let r = 0; r < Math.min(p.targets.length, k); r++) ideal += 1 / Math.log2(r + 2)
    const ndcg = ideal > 0 ? dcg / ideal : 0

    mrrs.push(mrr)
    recalls.push(recall)
    precisions.push(precision)
    hits.push(hit)
    ndcgs.push(ndcg)
    byTypeRaw[type].mrrs.push(mrr)
    byTypeRaw[type].recalls.push(recall)
    byTypeRaw[type].hits.push(hit)
    byTypeRaw[type].ndcgs.push(ndcg)
  }

  const overall: EvalOverall = {
    queries: pairs.length,
    mrrAtK: mean(mrrs),
    recallAtK: mean(recalls),
    precisionAtK: mean(precisions),
    hitAtK: mean(hits),
    ndcgAtK: mean(ndcgs),
    selfHitAtK: selfHits,
  }
  const byType: EvalByType = {}
  for (const t of Object.keys(byTypeRaw)) {
    const r = byTypeRaw[t]
    byType[t] = {
      queries: r.mrrs.length,
      mrrAtK: mean(r.mrrs),
      recallAtK: mean(r.recalls),
      hitAtK: mean(r.hits),
      ndcgAtK: mean(r.ndcgs),
    }
  }
  return { variant: variantName, documents: documentName, overall, byType }
}
