// exports: score, hit, unit
// purity: io
// depends-on: paths

// Shared Rust ANN endpoints for CLI TypeScript tools (standalone processes only).
// Spawns _rustlib/target/release/assemble with JSON over stdin/stdout — the single
// source of truth for vector math (score/hit/unit), mirrored by _lib/score.ts.
//
// Safety boundary: CLI tools execute as standalone processes (import.meta.main guard),
// so spawning is safe. IPC tools run inside the opencode server process — they must
// use in-process _lib/score.ts, never this module (spawn in the server process locks opencode).

import { Bin } from "./paths"

export type Hit = { index: number; score: number }

export async function hit(query: Float32Array, vectors: Float32Array[], k: number): Promise<Hit[]> {
  const payload = JSON.stringify({
    query: Array.from(query),
    vector: vectors.map(v => Array.from(v)),
    k,
  })
  const text = await output("hit", payload)
  const data = JSON.parse(text)
  return (data.hit || []) as Hit[]
}

export async function score(first: Float32Array, second: Float32Array): Promise<number> {
  const text = await output("score", JSON.stringify({ first: Array.from(first), second: Array.from(second) }))
  return JSON.parse(text).score as number
}

export async function unit(vector: Float32Array): Promise<Float32Array> {
  const text = await output("unit", JSON.stringify({ vector: Array.from(vector) }))
  const data = JSON.parse(text).unit as number[]
  return Float32Array.from(data)
}

async function output(verb: string, payload: string): Promise<string> {
  const proc = Bun.spawn([Bin, verb], { stdin: "pipe", stdout: "pipe" })
  proc.stdin.write(payload)
  proc.stdin.end()
  const text = await new Response(proc.stdout).text()
  const exit = await proc.exited
  if (exit !== 0) {
    throw new Error(`assemble ${verb} failed (exit ${exit})`)
  }
  return text
}
