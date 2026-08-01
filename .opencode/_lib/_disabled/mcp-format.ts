// exports: formatSearchResults, formatEntityDetail, formatValidationReport
// purity: pure
// depends-on: mcp-types

import type { SearchRow, EntityDetail, ValidationResult, IllustrationRelation } from "./mcp-types"

export function formatSearchResults(rows: SearchRow[], entityType: string): string {
  if (rows.length === 0) return `No ${entityType} found.`

  if (entityType === "skills") {
    const lines = rows.map(r => `${r.id} ${r.title} [${r.state_profile ?? "?"}]`)
    lines.push(`\n${rows.length} skills.`)
    return lines.join("\n")
  }

  if (entityType === "patterns") {
    const lines: string[] = []
    for (const r of rows) {
      const src = r.source ? ` [${r.source}]` : ""
      const t = r.tags ? ` (${r.tags})` : ""
      lines.push(`${r.id} ${r.title}${src}${t}`)
      if (r.summary) {
        const s = String(r.summary)
        lines.push(`  ${s.length > 80 ? s.slice(0, 80) + "..." : s}`)
      }
    }
    lines.push(`\n${rows.length} patterns.`)
    return lines.join("\n")
  }

  const label = entityType.charAt(0).toUpperCase() + entityType.slice(1)
  const lines = rows.map(r => {
    const src = r.source ? ` [${r.source}]` : ""
    const t = r.tags ? ` (${r.tags})` : ""
    return `${r.id} ${r.title}${src}${t}`
  })
  lines.push(`\n${rows.length} ${entityType}.`)
  return lines.join("\n")
}

export function formatEntityDetail(detail: EntityDetail, entityType: string): string {
  const { id, title, body } = detail
  const out: string[] = [`\n${id} ${title}`, "-".repeat(60), "", body]

  const meta: string[] = []
  if (detail.description) meta.push(`  Description: ${detail.description}`)
  if (detail.summary) meta.push(`  Summary: ${detail.summary}`)
  if (detail.principle) meta.push(`  Principle: ${detail.principle}`)
  if (detail.enforcement) meta.push(`  Enforcement: ${detail.enforcement}`)
  if (detail.status) meta.push(`  Status: ${detail.status}`)
  if (detail.priority != null) meta.push(`  Priority: ${detail.priority}`)
  if (detail.state_profile) meta.push(`  State profile: ${detail.state_profile}`)
  if (detail.protocol) meta.push(`  Protocol: ${detail.protocol}`)
  if (detail.source) meta.push(`  Source: ${detail.source}`)
  if (detail.tags) meta.push(`  Tags: ${detail.tags}`)
  if (detail.related) meta.push(`  Related: ${detail.related}`)
  if (meta.length > 0) out.push("", meta.join("\n"))

  return out.join("\n")
}

export function formatValidationReport(result: ValidationResult): string {
  const { counts, violations } = result
  const countLabels: string[] = []
  if (counts.patterns > 0) countLabels.push(`${counts.patterns} pattern${counts.patterns !== 1 ? "s" : ""}`)
  if (counts.terms > 0) countLabels.push(`${counts.terms} term${counts.terms !== 1 ? "s" : ""}`)
  if (counts.skills > 0) countLabels.push(`${counts.skills} skill${counts.skills !== 1 ? "s" : ""}`)
  if (counts.apologias > 0) countLabels.push(`${counts.apologias} apologia${counts.apologias !== 1 ? "s" : ""}`)
  if (counts.protocols > 0) countLabels.push(`${counts.protocols} protocol${counts.protocols !== 1 ? "s" : ""}`)
  if (counts.persons > 0) countLabels.push(`${counts.persons} person${counts.persons !== 1 ? "s" : ""}`)
  if (counts.illustrations > 0) countLabels.push(`${counts.illustrations} illustration${counts.illustrations !== 1 ? "s" : ""}`)
  if (counts.maxims > 0) countLabels.push(`${counts.maxims} maxim${counts.maxims !== 1 ? "s" : ""}`)

  if (violations.length === 0) {
    return `Validated ${countLabels.join(", ")}. All OK.`
  }

  return `Validated ${countLabels.join(", ")}.\n\nViolations:\n${violations.join("\n")}`
}

export function formatIllustrationPairs(rels: IllustrationRelation[]): string {
  if (rels.length === 0) return "No illustration relationships found."

  const groups = new Map<string, IllustrationRelation[]>()
  for (const r of rels) {
    const existing = groups.get(r.illustration_id) ?? []
    existing.push(r)
    groups.set(r.illustration_id, existing)
  }

  const lines: string[] = []
  for (const [illId, members] of groups) {
    const title = members[0].illustration_title
    lines.push(`\n${illId} (${title})`)
    for (const m of members) {
      lines.push(`  ${m.entity_type}::${m.entity_id} — ${m.entity_title}`)
    }
  }
  lines.push(`\n${rels.length} relationships across ${groups.size} illustrations.`)
  return lines.join("\n")
}
