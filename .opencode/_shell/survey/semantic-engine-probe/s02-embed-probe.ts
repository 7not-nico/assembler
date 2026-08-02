#!/usr/bin/env -S bun run
// s02-embed-probe.ts — time long-input embedding of Xenova/bge-small-en-v1.5
// Answers: does the model truncate long inputs, and at what cost?
// Emits keyed lines (LEN= DIMS= MS=) per NEX.ACQUIRE.PIPELINE handoff.
// Usage: bun run s02-embed-probe.ts [max_len]

import { pipeline } from "@huggingface/transformers"

const Model = "Xenova/bge-small-en-v1.5"
const maxLen = Number(process.argv[2] || "20000")

const pipe = await pipeline("feature-extraction", Model)
const t0 = performance.now()
for (const len of [100, 2000, 8000, maxLen]) {
  const text = "semantic engine diagnostic probe passage. ".repeat(Math.ceil(len / 36)).slice(0, len)
  const t1 = performance.now()
  const r = await pipe(text, { pooling: "cls", normalize: true })
  const t2 = performance.now()
  console.log(`LEN=${len} DIMS=${JSON.stringify(r.dims)} MS=${(t2 - t1).toFixed(1)}`)
}
console.log(`MODEL_LOAD_MS=${(performance.now() - t0).toFixed(1)}`)
