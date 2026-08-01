// exports: formatAuditResult, formatAuditReportAll
// purity: pure
// depends-on: compartment-audit (type only)

import type { AuditResult, Violation } from "./compartment-audit"

function formatViolations(violations: Violation[]): string {
  if (violations.length === 0) return "  OK"
  return violations.map(v => `  ${v.field}: ${v.message}`).join("\n")
}

export function formatAuditResult(result: AuditResult): string {
  const status = result.present ? (result.violations.length === 0 ? "PASS" : "FAIL") : "MISSING"
  const lines: string[] = [
    `${result.name} [${status}]`,
    `  Path: ${result.path}`,
  ]
  if (result.present) {
    lines.push(formatViolations(result.violations))
  } else {
    lines.push("  No compartment.yaml found")
  }
  return lines.join("\n")
}

export function formatAuditReportAll(results: AuditResult[]): string {
  if (results.length === 0) return "No subprojects found."

  const passed = results.filter(r => !r.present || r.violations.length === 0).length
  const failed = results.filter(r => r.present && r.violations.length > 0)
  const missing = results.filter(r => !r.present)

  const summary = `Audited ${results.length} subprojects: ${passed} compliant, ${failed.length} with violations, ${missing.length} without declarations.`

  if (failed.length === 0 && missing.length === 0) return `${summary}\nAll clean.`

  const sections: string[] = [summary, ""]

  if (failed.length > 0) {
    sections.push("--- Violations ---")
    for (const r of failed) sections.push(formatAuditResult(r))
    sections.push("")
  }

  if (missing.length > 0) {
    sections.push("--- Missing compartment.yaml ---")
    for (const r of missing) sections.push(`  ${r.name}`)
  }

  return sections.join("\n")
}
