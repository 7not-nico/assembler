// exports: createAudit, resolveRef, checkFilePairing
// purity: io
// depends-on: db, paths, errors, fs

import { readdirSync, existsSync } from "fs"
import { join } from "path"
import { Database, type BunFile } from "bun:sqlite"
import { initDB, queryOne } from "./db"
import { crashOnError } from "./errors"
export type { Violation, AuditContext } from "./audit-format"
export { checkDuplicate, formatReport } from "./audit-format"
import type { Violation, AuditContext } from "./audit-format"

export function createAudit(dir: string, ext: string): AuditContext {
  crashOnError()
  return {
    db: initDB(),
    violations: [],
    seenIDs: new Set(),
    files: readdirSync(dir).filter(f => f.endsWith(ext)).sort(),
  }
}

const CROSSREF_SQL = [
  "SELECT id FROM patterns WHERE id = $ref",
  "UNION SELECT id FROM terms WHERE id = $ref",
  "UNION SELECT id FROM rules WHERE id = $ref",
  "UNION SELECT id FROM skills WHERE id = $ref",
  "UNION SELECT id FROM commands WHERE id = $ref",
  "UNION SELECT id FROM persons WHERE id = $ref",
].join(" ")

export function resolveRef(db: Database, ref: string): boolean {
  return !!queryOne(db, CROSSREF_SQL, { $ref: ref })
}

export function checkFilePairing(yamlDir: string, mdDir: string, violations: Violation[], file: string): void {
  const yamlFiles = readdirSync(yamlDir).filter(f => f.endsWith(".yaml")).map(f => f.replace(/\.yaml$/, ""))
  const mdFiles = readdirSync(mdDir).filter(f => f.endsWith(".md")).map(f => f.replace(/\.md$/, ""))
  for (const name of yamlFiles) {
    if (!mdFiles.includes(name))
      violations.push({ file, message: `Missing .md file for YAML: ${name}` })
  }
  for (const name of mdFiles) {
    if (!yamlFiles.includes(name))
      violations.push({ file, message: `Missing .yaml file for .md: ${name}` })
  }
}
