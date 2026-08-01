// exports: formatEntityReport, formatEntityReportAll
// purity: pure
// depends-on: entity-audit (type only)

import type { Violation, AuditResult } from "./entity-audit"

export function formatEntityReport(result: AuditResult): string {
  const { path, type, score, violations } = result
  const summary = `File: ${path} (${type})\nClassification score: ${score}/100 — ${violations.length} violations.`

  if (violations.length === 0) return `${summary} All passed.`

  const lines: string[] = [summary, ""]
  for (const v of violations) {
    lines.push(`  Line ${v.line}: [${v.rule}] ${v.message}`)
  }
  return lines.join("\n")
}

export function formatEntityReportAll(results: AuditResult[]): string {
  if (results.length === 0) return "No files audited."

  const passed = results.filter(r => r.violations.length === 0).length
  const failed = results.filter(r => r.violations.length > 0)
  const summary = `Audited ${results.length} files: ${passed} passed, ${failed.length} failed.`

  if (failed.length === 0) return `${summary} All clean.`

  return [summary, "", ...failed.map(r => formatEntityReport(r))].join("\n")
}
