// exports: formatSearch, formatStats, formatDrift, formatPurge, formatEmbed, formatEval
// purity: pure
// depends-on: semantic-types (import type)

import type {
  SearchHit, TableStat, DriftReport, PurgeReport, EmbedSummary,
  EvalOverall, EvalByType,
} from "./semantic-types"

export function formatSearch(hits: SearchHit[], query: string, indexed: number): string {
  const line = (h: SearchHit) => `${String(h.rank).padEnd(5)} ${h.score.toFixed(4).padEnd(9)} ${h.type.padEnd(12)} ${h.id}\n       ${h.title.slice(0, 96)}`
  return [
    "RANK  SCORE    TYPE        ID",
    "-".repeat(70),
    ...hits.map(line),
    "-".repeat(70),
    `${hits.length} semantic matches for "${query}" (${indexed} indexed)`,
  ].join("\n")
}

export function formatStats(rows: TableStat[], total: number): string {
  const header = `${"TABLE".padEnd(20)} ${"COUNT".padStart(6)} ${"MODELS".padStart(7)} ${"DIM".padStart(7)}`
  const line = (r: TableStat) => `${r.table.padEnd(20)} ${String(r.count).padStart(6)} ${String(r.models).padStart(7)} ${String(r.dim).padStart(7)}`
  return [header, "-".repeat(44), ...rows.map(line), "-".repeat(44), `TOTAL: ${total} embeddings`].join("\n")
}

export function formatDrift(report: DriftReport, tables: number): string {
  const header = `${"TABLE".padEnd(18)} ${"DB".padStart(4)} ${"VEC".padStart(4)} ${"MISS".padStart(4)} ${"STALE".padStart(5)}`
  const lines = report.lines.map(l =>
    `${l.table.padEnd(18)} ${String(l.db).padStart(4)} ${String(l.vec).padStart(4)} ${String(l.missing).padStart(4)} ${String(l.stale).padStart(5)}`)
  return [
    header, "-".repeat(40), ...lines, "-".repeat(40),
    `TOTAL: ${report.missingTotal} missing, ${report.staleTotal} stale across ${tables} tables`,
  ].join("\n")
}

export function formatPurge(report: PurgeReport): string {
  const head = `${report.staleTotal} stale embeddings ${report.applied ? "purged" : "found (dry-run — use apply=true to purge)"}`
  return [head, ...report.sample.map(s => `  ${s}`)].join("\n")
}

export function formatEmbed(summaries: EmbedSummary[], total: number): string {
  return [...summaries.map(s => `embedded ${s.embedded} ${s.table}`), `\n${total} entities embedded`].join("\n")
}

export function formatEval(
  variant: string,
  documents: string,
  k: number,
  overall: EvalOverall,
  byType: EvalByType,
): string {
  const perType = Object.keys(byType).sort().map(t => {
    const r = byType[t]
    return `${t.padEnd(20)} ${String(r.queries).padEnd(6)} ${r.mrrAtK.toFixed(4).padEnd(8)} ${r.recallAtK.toFixed(4).padEnd(8)} ${r.hitAtK.toFixed(4).padEnd(8)} ${r.ndcgAtK.toFixed(4).padEnd(8)}`
  })
  return [
    `variant: ${variant}`,
    `documents: ${documents}`,
    `vectors: ${overall.queries}`,
    `labeled pairs: ${overall.queries}`,
    "",
    `MRR@${k}: ${overall.mrrAtK.toFixed(4)}`,
    `Recall@${k}: ${overall.recallAtK.toFixed(4)}`,
    `Precision@${k}: ${overall.precisionAtK.toFixed(4)}`,
    `Hit@${k}: ${overall.hitAtK.toFixed(4)}`,
    `NDCG@${k}: ${overall.ndcgAtK.toFixed(4)}`,
    `Self-hit@${k}: ${overall.selfHitAtK}/${overall.queries}`,
    "",
    "Per type",
    "-".repeat(70),
    `${"TYPE".padEnd(20)} ${"Q".padEnd(6)} ${"MRR".padEnd(8)} ${"RECALL".padEnd(8)} ${"HIT".padEnd(8)} ${"NDCG".padEnd(8)}`,
    ...perType,
  ].join("\n")
}
