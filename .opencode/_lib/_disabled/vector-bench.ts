// exports: runBenchmark, SearchResult, BenchmarkResult
// purity: io
// depends-on: ./embedder-onnx, bun:sqlite, ../_lib/db

import type { Database } from "bun:sqlite"

export interface SearchResult {
  entity_type: string
  entity_id: string
  score: number
}

export interface QueryTest {
  query: string
  type: string
  expectedId: string
  expectedType: string
  label: string
}

export interface BenchmarkResult {
  coldEmbedMs: number
  warmEmbedMs: number
  cosineScanMs: number
  fts5ScanMs: number
  totalWarmMs: number
  totalColdMs: number
  vectorOnlyHits: number
  fts5Hits: number
  hybridHits: number
  totalTests: number
  vectorCount: number
}

export async function runBenchmark(
  patlib: Database,
  vdb: Database,
  embedFn: (text: string) => Promise<Float32Array>,
  tests: QueryTest[],
): Promise<BenchmarkResult> {
  const N = (vdb.query("SELECT COUNT(*) as c FROM embeddings WHERE field = 'full'").get() as any).c
  const allVecs = vdb.query("SELECT entity_type, entity_id, vector FROM embeddings WHERE field = 'full'").all() as any[]

  // cold embed (includes model load)
  const t0 = performance.now()
  await embedFn("cold start benchmark initialization")
  const tCold = performance.now() - t0

  // warm embed benchmark (5 runs)
  let warmTimes: number[] = []
  for (let i = 0; i < 5; i++) {
    const t = performance.now()
    await embedFn(`warm query number ${i}`)
    warmTimes.push(performance.now() - t)
  }
  const avgWarmEmbed = warmTimes.slice(1).reduce((a, b) => a + b, 0) / (warmTimes.length - 1)

  // cosine scan benchmark (100 iterations)
  const queryVec = await embedFn("benchmark vector for cosine scan")
  const tScan = performance.now()
  for (let iter = 0; iter < 100; iter++) {
    for (const r of allVecs) {
      const v = new Float32Array(r.vector)
      let dot = 0, na = 0, nb = 0
      for (let i = 0; i < 384; i++) { dot += queryVec[i]*v[i]; na += queryVec[i]*queryVec[i]; nb += v[i]*v[i] }
      const _score = dot / (Math.sqrt(na) * Math.sqrt(nb))
    }
  }
  const avgCosineScan = (performance.now() - tScan) / 100

  // FTS5 scan benchmark
  const tFts = performance.now()
  for (let iter = 0; iter < 100; iter++) {
    vdb.query("SELECT e.entity_id FROM fts_entities e JOIN entities_fts f ON e.id = f.rowid WHERE e.entity_type = 'cognitions' AND entities_fts MATCH 'computer' LIMIT 5").all()
  }
  const avgFts5Scan = (performance.now() - tFts) / 100

  // run query tests
  let vectorHits = 0, fts5Hits = 0, hybridHits = 0
  for (const test of tests) {
    const qvec = await embedFn(test.query)

    // vector search
    let bestVec = { score: -1, type: "", id: "" }
    for (const r of allVecs) {
      if (r.entity_type !== test.type) continue
      const v = new Float32Array(r.vector)
      let dot = 0, na = 0, nb = 0
      for (let i = 0; i < 384; i++) { dot += qvec[i]*v[i]; na += qvec[i]*qvec[i]; nb += v[i]*v[i] }
      const score = dot / (Math.sqrt(na) * Math.sqrt(nb))
      if (score > bestVec.score) bestVec = { score, type: r.entity_type, id: r.entity_id }
    }
    if (bestVec.id === test.expectedId) vectorHits++

    // FTS5 keyword
    const terms = test.query.split(/\s+/).filter(Boolean).join(" OR ")
    try {
      const ftsRows = vdb.query("SELECT e.entity_id FROM fts_entities e JOIN entities_fts f ON e.id = f.rowid WHERE e.entity_type = ? AND entities_fts MATCH ? LIMIT 5").all(test.type, terms) as any[]
      if (ftsRows.some((r: any) => r.entity_id === test.expectedId)) fts5Hits++
      if (bestVec.id === test.expectedId || ftsRows.some((r: any) => r.entity_id === test.expectedId)) hybridHits++
    } catch {}

    console.log(`  ${test.label.padEnd(30)} v=${bestVec.id.slice(0,25).padEnd(25)} f=${test.expectedId.slice(0,25)} ${bestVec.id === test.expectedId ? '✓' : ' '}${fts5Hits ? '✓' : ' '}`)
  }

  return {
    coldEmbedMs: tCold,
    warmEmbedMs: avgWarmEmbed,
    cosineScanMs: avgCosineScan,
    fts5ScanMs: avgFts5Scan,
    totalWarmMs: avgWarmEmbed + avgCosineScan + avgFts5Scan,
    totalColdMs: tCold + avgCosineScan + avgFts5Scan,
    vectorOnlyHits: vectorHits,
    fts5Hits,
    hybridHits,
    totalTests: tests.length,
    vectorCount: N,
  }
}
