#!/usr/bin/env -S bun run
// @toolclass ANAL
// Semantic evaluation over patlib embeddings — computes MRR@K, Recall@K, P@K
// from related-ID labels and self-retrieval. Supports query variants.
// Usage: bun run .opencode/tools/semantic-eval.ts [--k N] [--variant default|raw|passage] [--documents stored|title|body]
// import.meta.main guard: zero side effects at discovery-import.

import { Database } from "bun:sqlite"
import { batch, Model } from "../_lib/embed"
import { Database as CorePath, Store } from "../_lib/paths"
import { cli } from "../_lib/cli"

const Internal = new Set([
  "embeddings", "fts_entities", "entities_fts",
  "meta", "notes", "sqlite_sequence",
])
const MetaCols = new Set(["id", "source", "tags", "status", "reference", "type", "created", "modified", "enforcement", "priority"])

type Entity = { id: string; type: string; title: string; body: string }
type Pair = { queryId: string; queryText: string; targets: string[] }
type Variant = { name: string; embed: (texts: string[]) => Promise<Float32Array[]> }

async function embedChunks(
  embed: (texts: string[]) => Promise<Float32Array[]>,
  texts: string[],
  size: number
): Promise<Float32Array[]> {
  const vectors: Float32Array[] = []
  for (let start = 0; start < texts.length; start += size) {
    const chunk = texts.slice(start, start + size)
    vectors.push(...await embed(chunk))
    console.log(`embedded batch ${Math.min(start + size, texts.length)}/${texts.length}`)
  }
  return vectors
}

function dot(a: Float32Array, b: Float32Array): number {
  let s = 0
  for (let i = 0; i < a.length; i++) s += a[i] * b[i]
  return s
}

function topK(query: Float32Array, pool: Float32Array[], k: number): { index: number; score: number }[] {
  const scores: { index: number; score: number }[] = []
  for (let i = 0; i < pool.length; i++) {
    scores.push({ index: i, score: dot(query, pool[i]) })
  }
  scores.sort((a, b) => b.score - a.score)
  return scores.slice(0, k)
}

function mean(values: number[]): number {
  if (values.length === 0) return 0
  return values.reduce((a, b) => a + b, 0) / values.length
}

function parseRelated(value: string | null): string[] {
  if (!value) return []
  return value.split(",").map(s => s.trim()).filter(Boolean)
}

async function loadEntities(): Promise<{ entityMap: Record<string, Entity>; pairs: Pair[] }> {
  const core = new Database(CorePath)
  const exclude = Array.from(Internal).map(n => `'${n}'`).join(",")
  const tables = core.query(
    `SELECT name FROM sqlite_master
     WHERE type='table'
       AND sql LIKE '%id TEXT%'
       AND sql LIKE '%title TEXT%'
       AND name NOT IN (${exclude})`
  ).all() as { name: string }[]

  const entityMap: Record<string, Entity> = {}
  const pairs: Pair[] = []

  for (const t of tables) {
    const sample = core.query(`SELECT * FROM "${t.name}" LIMIT 1`).get() as Record<string, unknown> | null
    if (!sample) continue
    const columns = Object.keys(sample)
    const related = columns.includes("related") ? `, related` : ""
    const rows = core.query(`SELECT id, title${related} FROM "${t.name}"`).all() as Record<string, string>[]
    for (const r of rows) {
      if (!r.id) continue
      const e: Entity = { id: r.id, type: t.name, title: r.title || "", body: r.body || "" }
      entityMap[r.id] = e
      const related = parseRelated(r.related)
      if (related.length > 0 && e.title) {
        pairs.push({ queryId: e.id, queryText: e.title, targets: related })
      }
    }
  }

  core.close()
  return { entityMap, pairs }
}

async function loadVectors(): Promise<{ ids: string[]; types: string[]; pool: Float32Array[] }> {
  const store = new Database(Store)
  const rows = store.query(
    "SELECT entity_id, entity_type, vector FROM embeddings WHERE seq = 0 AND field = 'full'"
  ).all() as { entity_id: string; entity_type: string; vector: Buffer }[]
  store.close()

  const ids: string[] = []
  const types: string[] = []
  const pool: Float32Array[] = []
  for (const r of rows) {
    ids.push(r.entity_id)
    types.push(r.entity_type)
    pool.push(new Float32Array(r.vector.buffer, r.vector.byteOffset, r.vector.byteLength / 4))
  }
  return { ids, types, pool }
}

async function loadDocuments(): Promise<Record<string, { title: string; body: string }>> {
  const core = new Database(CorePath)
  const exclude = Array.from(Internal).map(n => `'${n}'`).join(",")
  const tables = core.query(`SELECT name FROM sqlite_master WHERE type='table' AND sql LIKE '%id TEXT%' AND sql LIKE '%title TEXT%' AND name NOT IN (${exclude})`).all() as { name: string }[]
  const documents: Record<string, { title: string; body: string }> = {}
  for (const t of tables) {
    const sample = core.query(`SELECT * FROM "${t.name}" LIMIT 1`).get() as Record<string, unknown> | null
    if (!sample) continue
    const columns = Object.keys(sample).filter(c => !MetaCols.has(c))
    const rows = core.query(`SELECT * FROM "${t.name}"`).all() as Record<string, unknown>[]
    for (const row of rows) {
      if (!row.id) continue
      const title = String(row.title || "").trim()
      const parts = [`${row.id}: ${title}`]
      for (const column of columns) {
        if (column === "title" || !row[column]) continue
        const value = String(row[column]).trim()
        if (value) parts.push(value.slice(0, 2000))
      }
      documents[`${t.name}:${row.id}`] = { title, body: parts.join(". ") }
    }
  }
  core.close()
  return documents
}

function evaluate(
  queryVectors: Float32Array[],
  pool: Float32Array[],
  ids: string[],
  pairs: Pair[],
  entityMap: Record<string, Entity>,
  k: number
): { overall: Record<string, number>; byType: Record<string, Record<string, number>>; selfHits: number } {
  const mrrs: number[] = []
  const recalls: number[] = []
  const precisions: number[] = []
  const hits: number[] = []
  const ndcgs: number[] = []
  const byType: Record<string, { mrrs: number[]; recalls: number[]; precisions: number[]; hits: number[]; ndcgs: number[] }> = {}
  let selfHits = 0

  for (let i = 0; i < pairs.length; i++) {
    const p = pairs[i]
    const top = topK(queryVectors[i], pool, k)
    const topIds = top.map(t => ids[t.index])
    const type = entityMap[p.queryId]?.type || "unknown"
    if (!byType[type]) byType[type] = { mrrs: [], recalls: [], precisions: [], hits: [], ndcgs: [] }

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
    byType[type].mrrs.push(mrr)
    byType[type].recalls.push(recall)
    byType[type].precisions.push(precision)
    byType[type].hits.push(hit)
    byType[type].ndcgs.push(ndcg)
  }

  const overall = {
    queries: pairs.length,
    mrrAtK: mean(mrrs),
    recallAtK: mean(recalls),
    precisionAtK: mean(precisions),
    hitAtK: mean(hits),
    ndcgAtK: mean(ndcgs),
    selfHitAtK: selfHits,
  }

  const byTypeResult: Record<string, Record<string, number>> = {}
  for (const type of Object.keys(byType)) {
    byTypeResult[type] = {
      queries: byType[type].mrrs.length,
      mrrAtK: mean(byType[type].mrrs),
      recallAtK: mean(byType[type].recalls),
      precisionAtK: mean(byType[type].precisions),
      hitAtK: mean(byType[type].hits),
      ndcgAtK: mean(byType[type].ndcgs),
    }
  }

  return { overall, byType: byTypeResult, selfHits }
}

async function main() {
  const { value } = cli(process.argv.slice(2))
  const k = Number(value("--k") || "10")
  const variantName = (value("--variant") || "default") as string
  const documentName = value("--documents") || "stored"
  const batchSize = Number(value("--batch-size") || "16")

  const { entityMap, pairs } = await loadEntities()
  const { ids, types, pool: storedPool } = await loadVectors()

  if (pairs.length === 0) {
    console.error("no labeled pairs found")
    process.exit(1)
  }
  if (storedPool.length === 0) {
    console.error("no embeddings found")
    process.exit(1)
  }

  const variants: Record<string, Variant> = {
    default: { name: "default", embed: (texts) => batch(texts.map(t => `Represent this sentence for searching relevant passages: ${t}`)) },
    raw: { name: "raw", embed: batch },
    passage: { name: "passage", embed: (texts) => batch(texts.map(t => `passage: ${t}`)) },
  }

  const variant = variants[variantName]
  if (!variant) {
    console.error(`unknown variant: ${variantName}`)
    process.exit(1)
  }

  const queryTexts = pairs.map(p => p.queryText)
  const queryVectors = await embedChunks(variant.embed, queryTexts, batchSize)
  let pool = storedPool
  if (documentName !== "stored") {
    const documents = await loadDocuments()
    const texts = ids.map((id, i) => {
      const document = documents[`${types[i]}:${id}`]
      if (!document) return id
      return documentName === "title" ? document.title : document.body
    })
    pool = await embedChunks(batch, texts, batchSize)
  }
  if (!(documentName === "stored" || documentName === "title" || documentName === "body")) {
    console.error(`unknown document variant: ${documentName}`)
    process.exit(1)
  }

  const { overall, byType, selfHits } = evaluate(queryVectors, pool, ids, pairs, entityMap, k)

  console.log(`variant: ${variant.name}`)
  console.log(`documents: ${documentName}`)
  console.log(`model: ${Model}`)
  console.log(`vectors: ${pool.length}`)
  console.log(`labeled pairs: ${pairs.length}`)
  console.log("")
  console.log(`MRR@${k}: ${overall.mrrAtK.toFixed(4)}`)
  console.log(`Recall@${k}: ${overall.recallAtK.toFixed(4)}`)
  console.log(`Precision@${k}: ${overall.precisionAtK.toFixed(4)}`)
  console.log(`Hit@${k}: ${overall.hitAtK.toFixed(4)}`)
  console.log(`NDCG@${k}: ${overall.ndcgAtK.toFixed(4)}`)
  console.log(`Self-hit@${k}: ${selfHits}/${pairs.length}`)
  console.log("")
  console.log("Per type")
  console.log("-".repeat(70))
  console.log(`${"TYPE".padEnd(20)} ${"Q".padEnd(6)} ${"MRR".padEnd(8)} ${"RECALL".padEnd(8)} ${"HIT".padEnd(8)} ${"NDCG".padEnd(8)}`)
  for (const type of Object.keys(byType).sort()) {
    const r = byType[type]
    console.log(`${type.padEnd(20)} ${String(r.queries).padEnd(6)} ${r.mrrAtK.toFixed(4).padEnd(8)} ${r.recallAtK.toFixed(4).padEnd(8)} ${r.hitAtK.toFixed(4).padEnd(8)} ${r.ndcgAtK.toFixed(4).padEnd(8)}`)
  }
}

if (import.meta.main) {
  main()
}
