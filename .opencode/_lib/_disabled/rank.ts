// exports: rrf, SearchResult
// purity: pure
// depends-on: none

export interface SearchResult {
  entity_type: string
  entity_id: string
  score: number
  source?: "vector" | "keyword" | "hybrid"
}

const RRF_K = 60

export function rrf(
  vectorHits: Array<{ entity_type: string; entity_id: string; rank: number }>,
  keywordHits: Array<{ entity_type: string; entity_id: string; rank: number }>,
  limit: number,
): SearchResult[] {
  const combined = new Map<string, { entity_type: string; entity_id: string; score: number }>()

  for (const h of vectorHits) {
    const key = `${h.entity_type}:${h.entity_id}`
    combined.set(key, { entity_type: h.entity_type, entity_id: h.entity_id, score: 1 / (RRF_K + h.rank) })
  }

  for (const h of keywordHits) {
    const key = `${h.entity_type}:${h.entity_id}`
    const existing = combined.get(key)
    if (existing) {
      existing.score += 1 / (RRF_K + h.rank)
    } else {
      combined.set(key, { entity_type: h.entity_type, entity_id: h.entity_id, score: 1 / (RRF_K + h.rank) })
    }
  }

  return Array.from(combined.values())
    .sort((a, b) => b.score - a.score)
    .slice(0, limit)
    .map(r => ({ ...r, score: Math.round(r.score * 1000) / 1000, source: "hybrid" as const }))
}
