// exports: embed, embedBatch, cosine, computeHashAsync, getModel
// purity: io (registers @huggingface/transformers pipeline as the embedder implementation)
// depends-on: ./embedder, @huggingface/transformers
// notes: Shared embedder implementation for all vector tools (reindex, bench, MCP).
//   Imports from _lib/embedder (registry) and registers the ONNX pipeline.
//   All tools import from here instead of cross-importing from each other.

import { setEmbedder, embed, embedBatch, cosine, computeHashAsync, getModel } from "./embedder"

let pipelineFn: any = null

const REAL_MODEL = "Xenova/bge-small-en-v1.5"

setEmbedder({
  model: REAL_MODEL,
  embed: async (text: string) => {
    if (!pipelineFn) {
      const mod = await import("@huggingface/transformers")
      pipelineFn = await mod.pipeline("feature-extraction", REAL_MODEL)
    }
    const result = await pipelineFn(text, { pooling: "mean", normalize: true })
    return new Float32Array(result.data)
  },
  embedBatch: async (texts: string[]) => {
    if (texts.length === 0) return []
    if (!pipelineFn) {
      const mod = await import("@huggingface/transformers")
      pipelineFn = await mod.pipeline("feature-extraction", REAL_MODEL)
    }
    const result = await pipelineFn(texts, { pooling: "mean", normalize: true })
    const output = result as { data: { length: number }; dims: number[] }
    const dim = output.dims[output.dims.length - 1]
    const vecs: Float32Array[] = []
    for (let i = 0; i < texts.length; i++) {
      const start = i * dim
      vecs.push(new Float32Array(output.data.slice(start, start + dim)))
    }
    return vecs
  },
  cosine: (a: Float32Array, b: Float32Array): number => {
    let dot = 0, na = 0, nb = 0
    for (let i = 0; i < a.length; i++) {
      dot += a[i] * b[i]
      na += a[i] * a[i]
      nb += b[i] * b[i]
    }
    const denom = Math.sqrt(na) * Math.sqrt(nb)
    return denom === 0 ? 0 : dot / denom
  },
})

export { embed, embedBatch, cosine, computeHashAsync, getModel }
