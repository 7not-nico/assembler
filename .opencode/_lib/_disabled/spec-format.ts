// exports: formatAuditReport, formatRuleList
// purity: pure
// depends-on: none

import type { AuditResult, Rule } from "./spec-types"

export function formatAuditReport(result: AuditResult): string {
  const { score, total, violations } = result
  const errors = violations.filter(v => v.severity === "error")
  const warns = violations.filter(v => v.severity === "warn")
  const summary = `Compliance score: ${score}/100 — ${errors.length} errors, ${warns.length} warnings across ${total} rules.`

  if (violations.length === 0) return `${summary} All passed.`

  const byLine = new Map<number, typeof violations>()
  for (const v of violations) {
    const arr = byLine.get(v.line) || []
    arr.push(v)
    byLine.set(v.line, arr)
  }

  const body: string[] = [summary, ""]
  for (const [line, vs] of [...byLine.entries()].sort((a, b) => a[0] - b[0])) {
    body.push(`Line ${line}:`)
    for (const v of vs) {
      const tag = v.severity === "error" ? "ERR" : "WARN"
      body.push(`  [${tag}] ${v.title}: ${v.message}`)
      if (v.suggestion) body.push(`         → ${v.suggestion}`)
    }
  }

  return body.join("\n")
}

export function formatRuleList(rules: Rule[]): string {
  return rules.map(r =>
    `${r.id} [${r.severity}] ${r.title}\n  ${r.description ?? ""}\n  Type: ${r.checkType} | Scope: ${r.scope}`
  ).join("\n\n")
}
