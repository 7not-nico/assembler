// @toolclass RECG
// purity: io
// depends-on: paths, audit, parse, fs, path
import { tool } from "@opencode-ai/plugin"
import { readFileSync } from "fs"
import { join } from "path"
import { PATTERNS_DIR } from "../_lib/paths"
import { createAudit, resolveRef, checkDuplicate, formatReport } from "../_lib/audit"
import type { Violation } from "../_lib/audit"
import { validateEntityFile, pluralize } from "../_lib/parse"

const VALID_ENFORCEMENT = new Set(["Tool", "Convention", "Review"])
const VALID_STATUS = new Set(["active", "draft", "deprecated"])
const REQUIRED_BODY_SECTIONS = ["## Rules", "## Applicability", "## See also"]

export default tool({
  description: "Audit all .opencode/patterns/ files for structural and semantic compliance",
  args: {},
  async execute() {
    const ctx = createAudit(PATTERNS_DIR, ".md")
    const { db, violations, files } = ctx

    for (const file of files) {
      const path = join(PATTERNS_DIR, file)
      const text = readFileSync(path, "utf-8")
      const r = validateEntityFile(text, "pattern")
      if (!r.yaml) {
        for (const v of r.violations) violations.push({ file, message: v })
        continue
      }
      const { yaml: fm, body } = r

      if (fm.title && !String(fm.title).includes("—"))
        violations.push({ file, message: `Title "${fm.title}" missing em-dash (—) between name and subtitle` })

      if (fm.enforcement && !VALID_ENFORCEMENT.has(fm.enforcement as string))
        violations.push({ file, message: `Enforcement "${fm.enforcement}" must be one of: ${[...VALID_ENFORCEMENT].join(", ")}` })

      if (fm.status && !VALID_STATUS.has(fm.status as string))
        violations.push({ file, message: `Status "${fm.status}" must be one of: ${[...VALID_STATUS].join(", ")}` })

      if (fm.priority !== undefined && fm.priority !== null) {
        const p = Number(fm.priority)
        if (!Number.isInteger(p) || p < 1 || p > 5)
          violations.push({ file, message: `Priority ${fm.priority} must be integer 1–5` })
        if (p === 1 && fm.id !== "MAX.DRY")
          violations.push({ file, message: `Priority 1 is reserved for MAX.DRY only; found on ${fm.id}` })
      }

      const tags = fm.tags ? String(fm.tags).split(",") : []
      if (tags.length < 3)
        violations.push({ file, message: `Tags has ${tags.length} entries, minimum 3` })

      for (const section of REQUIRED_BODY_SECTIONS) {
        if (!body || !body.includes(section))
          violations.push({ file, message: `Body missing required section: ${section}` })
      }

      const bodyMatch = body?.match(/^\*\*(.+?)\*\*\s*—/)
      if (bodyMatch && fm.title) {
        const boldFirst = bodyMatch[1]
        const titleName = String(fm.title).split("—")[0].trim()
        if (boldFirst !== titleName && !String(fm.title).startsWith(boldFirst))
          violations.push({ file, message: `Body bold "${boldFirst}" does not align with title "${fm.title}"` })
      }

      const PATLIB_ID_RE = /^[A-Z]{2,}(\.[A-Z][A-Z0-9.\-/]*)+$/
      const seeAlsoMatch = body?.match(/## See also\n([\s\S]*?)(?=\n## |$)/)
      if (seeAlsoMatch) {
        const seeAlsoLines = seeAlsoMatch[1].split("\n")
        for (const line of seeAlsoLines) {
          const refMatch = line.match(/^- (.+)$/)
          if (!refMatch) continue
          const raw = refMatch[1].trim().replace(/^`|`$/g, "")
          const candidate = raw.split(/ — | – | —– | –– /)[0].trim()
          if (!PATLIB_ID_RE.test(candidate)) continue
          if (!resolveRef(db, candidate))
            violations.push({ file, message: `See also ID "${candidate}" does not resolve in patlib.db` })
        }
      }

      if (fm.id) {
        const idStr = String(fm.id)
        checkDuplicate(ctx, idStr, file)
        const expectedFile = `${idStr}.md`
        if (file !== expectedFile)
          violations.push({ file, message: `File name "${file}" does not match expected "${expectedFile}"` })
      }
    }

    db.close()
    return formatReport(files, violations, "pattern files")
  },
})
