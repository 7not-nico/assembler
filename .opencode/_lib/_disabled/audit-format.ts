// exports: Violation, AuditContext, checkDuplicate, formatReport
// purity: pure
// depends-on: none

import type { Database } from "bun:sqlite"

export interface Violation {
  file: string
  message: string
}

export interface AuditContext {
  db: Database
  violations: Violation[]
  seenIDs: Set<string>
  files: string[]
}

export function checkDuplicate(ctx: AuditContext, id: string, file: string): void {
  if (ctx.seenIDs.has(id))
    ctx.violations.push({ file, message: `Duplicate ID: ${id}` })
  ctx.seenIDs.add(id)
}

export function formatReport(files: string[], violations: Violation[], entityLabel: string): string {
  if (violations.length === 0)
    return `Audited ${files.length} ${entityLabel}. All OK.`

  const report = violations.map(v => `  ${v.file}: ${v.message}`).join("\n")
  return `Audited ${files.length} ${entityLabel}. ${violations.length} violation${violations.length !== 1 ? "s" : ""}:\n${report}`
}
