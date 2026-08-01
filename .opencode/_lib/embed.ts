// exports: Model, Dimension, vector, query, batch
// purity: io
// depends-on: @huggingface/transformers

import { pipeline } from "@huggingface/transformers"

export const Model = "Xenova/bge-small-en-v1.5"
export const Dimension = 384
const QueryPrefix = "Represent this sentence for searching relevant passages: "

let pipe: any = null

export async function vector(text: string): Promise<Float32Array> {
  if (!pipe) {
    pipe = await pipeline("feature-extraction", Model)
  }
  let result = await pipe(text, { pooling: "cls", normalize: true })
  return new Float32Array(result.data)
}

export async function query(text: string): Promise<Float32Array> {
  return vector(QueryPrefix + text)
}

export async function batch(text: string[]): Promise<Float32Array[]> {
  if (text.length === 0) return []
  if (!pipe) {
    pipe = await pipeline("feature-extraction", Model)
  }
  let result = await pipe(text, { pooling: "cls", normalize: true })
  let dim = result.dims[result.dims.length - 1]
  let list: Float32Array[] = []
  for (let index = 0; index < text.length; index++) {
    let start = index * dim
    list.push(new Float32Array(result.data.slice(start, start + dim)))
  }
  return list
}
