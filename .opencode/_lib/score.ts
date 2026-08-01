// exports: score, unit, hit
// purity: pure
// depends-on: none

// Pure vector math — cosine score, L2 norm, top-k hits.
// Mirrors _rustlib/src/r0-vector.rs semantics; in-process (no spawn, no lock).

/// Cosine score between two slices
export function score(a: Float32Array, b: Float32Array): number {
  let dot = 0
  let la = 0
  let ra = 0
  for (let index = 0; index < a.length; index++) {
    dot += a[index] * b[index]
    la += a[index] * a[index]
    ra += b[index] * b[index]
  }
  const norm = Math.sqrt(la) * Math.sqrt(ra)
  return norm === 0 ? 0 : dot / norm
}

/// L2-normalized copy of a slice
export function unit(value: Float32Array): Float32Array {
  let sum = 0
  for (let index = 0; index < value.length; index++) sum += value[index] * value[index]
  const len = Math.sqrt(sum)
  if (len === 0) return new Float32Array(value.length)
  const out = new Float32Array(value.length)
  for (let index = 0; index < value.length; index++) out[index] = value[index] / len
  return out
}

/// Top-k nearest vectors by cosine similarity → [{ index, score }]
export function hit(query: Float32Array, vectors: Float32Array[], k: number): { index: number; score: number }[] {
  const norm = unit(query)
  const rank = new Array(vectors.length)
  for (let index = 0; index < vectors.length; index++) {
    rank[index] = { index: index, score: score(norm, vectors[index]) }
  }
  rank.sort((a, b) => b.score - a.score)
  return rank.slice(0, Math.max(0, Math.min(k, rank.length)))
}
