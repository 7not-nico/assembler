// @toolclass RECG
// purity: io
// depends-on: paths, audit, parse, fs, path
import { tool } from "@opencode-ai/plugin"
import { readFileSync } from "fs"
import { join } from "path"
import { TERMS_DIR } from "../_lib/paths"
import { createAudit, resolveRef, checkDuplicate, formatReport } from "../_lib/audit"
import type { Violation } from "../_lib/audit"
import { validateEntityFile, normalizeArray, pluralize } from "../_lib/parse"

export default tool({
  description: "Audit all .opencode/terms/ files for structural and semantic compliance",
  args: {},
  async execute() {
    const ctx = createAudit(TERMS_DIR, ".md")
    const { db, violations, files } = ctx

    for (const file of files) {
      const path = join(TERMS_DIR, file)
      const text = readFileSync(path, "utf-8").trim()
      const r = validateEntityFile(text, "term")
      if (!r.yaml) {
        for (const v of r.violations) violations.push({ file, message: v })
        continue
      }
      const { yaml: bm, body } = r

      if (!bm.source) violations.push({ file, message: "Missing source" })
      if (!bm.tags) violations.push({ file, message: "Missing tags" })
      if (!bm.reference) violations.push({ file, message: "Missing reference" })

      const bodyMatch = body?.match(/^\*\*(.+?)\*\*\s*—/)
      if (!bodyMatch)
        violations.push({ file, message: "Body must start with **{Name}** — (bold, space, em-dash)" })
      else if (bm.title && bodyMatch[1] !== bm.title)
        violations.push({ file, message: `Body bold title "${bodyMatch[1]}" does not match YAML title "${bm.title}"` })

      const tags = normalizeArray(bm.tags)
      if (!tags || tags.split(",").length < 3)
        violations.push({ file, message: "Tags has insufficient entries (< 3)" })

      if (Array.isArray(bm.reference)) {
        if (bm.reference.length < 3)
          violations.push({ file, message: `Reference has ${bm.reference.length} entries, minimum 3` })
        for (let i = 0; i < bm.reference.length; i++) {
          const ref = bm.reference[i]
          if (typeof ref !== "object" || ref === null) {
            violations.push({ file, message: `Reference entry ${i + 1} is not an object` })
            continue
          }
          const r2 = ref as Record<string, unknown>
          if (!r2.title) violations.push({ file, message: `Reference ${i + 1} missing title` })
          if (!r2.url) violations.push({ file, message: `Reference ${i + 1} missing url` })
        }
      } else {
        violations.push({ file, message: "Reference is not an array" })
      }

      if (bm.related) {
        const relatedIds = normalizeArray(bm.related)?.split(",") || []
        for (const ref of relatedIds) {
          const trimmed = ref.trim()
          if (!trimmed) continue
          if (!resolveRef(db, trimmed))
            violations.push({ file, message: `Related ID "${trimmed}" does not resolve in patlib.db` })
        }
      }

      if (bm.id) {
        const idStr = String(bm.id)
        checkDuplicate(ctx, idStr, file)
        const expectedFile = `${idStr}.md`
        if (file !== expectedFile)
          violations.push({ file, message: `File name "${file}" does not match expected "${expectedFile}"` })
      }
    }

    db.close()
    return formatReport(files, violations, "term files")
  },
})
