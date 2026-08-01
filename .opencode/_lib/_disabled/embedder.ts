// exports: setEmbedder, getModel, embed, embedBatch, cosine, computeHashAsync, EmbedFn, EmbedBatchFn, CosineFn
// purity: io (delegates to registered impure implementation at runtime)
// depends-on: none (registry pattern — tools provide implementation via setEmbedder)

export type EmbedFn = (text: string) => Promise<Float32Array>
export type EmbedBatchFn = (texts: string[]) => Promise<Float32Array[]>
export type CosineFn = (a: Float32Array, b: Float32Array) => number

interface EmbedderImpl {
  embed: EmbedFn
  embedBatch: EmbedBatchFn
  cosine: CosineFn
  model: string
}

let impl: EmbedderImpl | null = null

export function setEmbedder(e: EmbedderImpl): void {
  impl = e
}

export function getModel(): string {
  return impl?.model ?? "none"
}

export async function embed(text: string): Promise<Float32Array> {
  if (!impl) throw new Error("Embedder not registered. Import tool-level embedder.ts first.")
  return impl.embed(text)
}

export async function embedBatch(texts: string[]): Promise<Float32Array[]> {
  if (!impl) throw new Error("Embedder not registered. Import tool-level embedder.ts first.")
  return impl.embedBatch(texts)
}

export function cosine(a: Float32Array, b: Float32Array): number {
  if (!impl) throw new Error("Embedder not registered. Import tool-level embedder.ts first.")
  return impl.cosine(a, b)
}

export async function computeHashAsync(text: string): Promise<string> {
  const encoder = new TextEncoder()
  const hashBuf = await crypto.subtle.digest("SHA-256", encoder.encode(text))
  return Array.from(new Uint8Array(hashBuf)).map(b => b.toString(16).padStart(2, "0")).join("")
}
