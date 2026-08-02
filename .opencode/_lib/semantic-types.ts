// exports: SearchHit, TableStat, DriftLine, DriftReport, PurgeReport, EmbedSummary, EvalOverall, EvalByType
// purity: pure
// depends-on: (none)

export type SearchHit = { rank: number; score: number; type: string; id: string; title: string }

export type TableStat = { table: string; count: number; models: number; dim: number }

export type DriftLine = { table: string; db: number; vec: number; missing: number; stale: number }

export type DriftReport = { lines: DriftLine[]; missingTotal: number; staleTotal: number }

export type PurgeReport = { staleTotal: number; sample: string[]; applied: boolean }

export type EmbedSummary = { table: string; embedded: number }

export type EvalOverall = {
  queries: number
  mrrAtK: number
  recallAtK: number
  precisionAtK: number
  hitAtK: number
  ndcgAtK: number
  selfHitAtK: number
}

export type EvalByType = Record<string, {
  queries: number
  mrrAtK: number
  recallAtK: number
  hitAtK: number
  ndcgAtK: number
}>
