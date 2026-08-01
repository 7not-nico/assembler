// ann-tpl.ts — Go binary ANN endpoint for _templates semantic search
// purity: io
// depends-on: _golib/ann (Go binary, built via `go build -o ann .` in _golib/)

// Spawns the Go ANN worker with BINARY transport (raw f32 little-endian) —
// protocol: header nq|nv|dim|k (4×uint32 LE) → nq*dim queries → nv*dim pool
// → per-query k + k×(idx uint32, score f32). ~3.8× faster than in-process TS at
// scale (10k vectors); JSON transport defeated Rust (0.4×) — transport, not
// language, is the lever.
//
// Safety boundary: CLI tools run as standalone processes (import.meta.main guard),
// so spawning is safe. IPC contexts must use in-process scoring, never this module.

import * as path from "node:path"

const ROOT = path.resolve(import.meta.dir, "..")
const BIN = path.join(ROOT, "_golib", "ann")

export type Hit = { index: number; score: number }

/// Batch top-k over one pool. queries/pool are Float32Array rows; returns per-query hits.
export async function batch(queries: Float32Array[], pool: Float32Array[], k: number): Promise<Hit[][]> {
  const nq = queries.length
  const nv = pool.length
  const dim = queries[0]?.length ?? 0

  // Header + payload — binary buffers passed directly as stdin (Bun.spawn accepts TypedArray)
  const hdr = new Uint8Array(16)
  const dv = new DataView(hdr.buffer)
  dv.setUint32(0, nq, true)
  dv.setUint32(4, nv, true)
  dv.setUint32(8, dim, true)
  dv.setUint32(12, k, true)

  const qbuf = new Uint8Array(nq * dim * 4)
  const qdv = new DataView(qbuf.buffer)
  for (let i = 0; i < nq; i++) for (let j = 0; j < dim; j++) qdv.setFloat32((i * dim + j) * 4, queries[i][j], true)

  const pbuf = new Uint8Array(nv * dim * 4)
  const pdv = new DataView(pbuf.buffer)
  for (let i = 0; i < nv; i++) for (let j = 0; j < dim; j++) pdv.setFloat32((i * dim + j) * 4, pool[i][j], true)

  const input = new Uint8Array(16 + qbuf.length + pbuf.length)
  input.set(hdr, 0)
  input.set(qbuf, 16)
  input.set(pbuf, 16 + qbuf.length)

  const proc = Bun.spawn([BIN], { stdin: input, stdout: "pipe", stderr: "pipe" })
  const out = await Bun.readableStreamToArrayBuffer(proc.stdout)
  await proc.exited

  // Decode: per query — uint32 k, then k×(idx uint32, score f32)
  const view = new DataView(out)
  const results: Hit[][] = []
  let off = 0
  for (let q = 0; q < nq; q++) {
    const kk = view.getUint32(off, true); off += 4
    const hits: Hit[] = []
    for (let h = 0; h < kk; h++) {
      const index = view.getUint32(off, true); off += 4
      const score = view.getFloat32(off, true); off += 4
      hits.push({ index, score })
    }
    results.push(hits)
  }
  return results
}
