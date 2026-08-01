// exports: entityTable, cosineSearch, ENTITY_TYPES, SEARCH_MODES, toFtsQuery
// purity: pure
// depends-on: none

export const ENTITY_TYPES = [
  "patterns", "terms", "cognitions", "concepts", "definitions",
  "skills", "rules", "commands",
  "protocols", "abstractions", "linguistics", "apologias", "nexus",
  "persons", "illustrations", "maxims",
] as const

export const SEARCH_MODES = ["vector", "keyword", "hybrid"] as const
export const SCOPE_MODES = ["full", "meta", "body"] as const

export function toFtsQuery(raw: string): string {
  return raw.split(/\s+/).filter(Boolean).map(t => `"${t}"`).join(" OR ")
}

export function entityTable(type: string): string | null {
  const map: Record<string, string> = {
    patterns: "patterns", terms: "terms",
    cognitions: "cognitions", concepts: "concepts", definitions: "definitions",
    skills: "skills", rules: "rules", commands: "commands",
    protocols: "protocols", abstractions: "abstractions", linguistics: "linguistics",
    apologias: "apologias", nexus: "nexus",
    persons: "persons", illustrations: "illustrations", maxims: "maxims",
    taxonomy: "taxonomy",
    ml: "ml",
    bash: "bash",
    ruby: "ruby",
  }
  return map[type] ?? null
}

export function cosineSearch(
  queryVec: Float32Array,
  rows: Array<{ entity_type: string; entity_id: string; vector: Float32Array }>,
  limit: number,
): Array<{ entity_type: string; entity_id: string; score: number }> {
  const scored = rows.map(r => {
    let dot = 0, na = 0, nb = 0
    for (let i = 0; i < queryVec.length; i++) {
      dot += queryVec[i] * r.vector[i]
      na += queryVec[i] * queryVec[i]
      nb += r.vector[i] * r.vector[i]
    }
    const denom = Math.sqrt(na) * Math.sqrt(nb)
    return {
      entity_type: r.entity_type,
      entity_id: r.entity_id,
      score: denom === 0 ? 0 : dot / denom,
    }
  })
  scored.sort((a, b) => b.score - a.score)
  return scored.slice(0, limit)
}
