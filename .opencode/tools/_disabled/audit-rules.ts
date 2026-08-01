// @toolclass RECG
// purity: io
// depends-on: paths, audit, parse, fs, path
import { tool } from "@opencode-ai/plugin"
import { readFileSync } from "fs"
import { join } from "path"
import { RULES_DIR } from "../_lib/paths"
import { createAudit, resolveRef, checkDuplicate, formatReport, checkFilePairing } from "../_lib/audit"
import type { Violation } from "../_lib/audit"
import { parseYaml, pluralize } from "../_lib/parse"

const VALID_GROUPS = ["writing", "philosophy", "workflow", "system"] as const
const ID_RE = /^RUL\.[A-Z.]+$/
const RULES_MD_DIR = join(RULES_DIR, "..")

export default tool({
  description: "Audit all .opencode/rules/yamls/ YAML files for structural and semantic compliance",
  args: {},
  async execute() {
    const ctx = createAudit(RULES_DIR, ".yaml")
    const { db, violations, files } = ctx

    for (const file of files) {
      const path = join(RULES_DIR, file)
      const text = readFileSync(path, "utf-8")
      const yaml = parseYaml(text)
      if (!yaml) {
        violations.push({ file, message: "Unparseable YAML" })
        continue
      }
      const name = file.replace(/\.yaml$/, "")

      if (!yaml.id) violations.push({ file, message: "Missing id" })
      if (!yaml.title) violations.push({ file, message: "Missing title" })
      if (!yaml.source) violations.push({ file, message: "Missing source" })
      if (!yaml.tags) violations.push({ file, message: "Missing tags" })
      if (!yaml.group) violations.push({ file, message: "Missing group" })

      if (yaml.id && !ID_RE.test(yaml.id as string))
        violations.push({ file, message: `Malformed ID: ${yaml.id}` })

      if (yaml.title) {
        const mdPath = join(RULES_MD_DIR, `${name}.md`)
        try {
          const mdText = readFileSync(mdPath, "utf-8")
          const firstBold = mdText.match(/^\*\*(.+?)\*\*/)
          if (firstBold && firstBold[1] !== yaml.title)
            violations.push({ file, message: `Title mismatch: YAML="${yaml.title}" ≠ MD="${firstBold[1]}"` })
        } catch { /* skip if md missing */ }
      }

      if (yaml.source && yaml.source !== "assembler")
        violations.push({ file, message: `Source is "${yaml.source}", expected "assembler"` })

      if (Array.isArray(yaml.tags) && yaml.tags.length < 3)
        violations.push({ file, message: `Tags has ${yaml.tags.length} entries, minimum 3` })
      else if (!Array.isArray(yaml.tags))
        violations.push({ file, message: "Tags is not an inline array" })

      if (yaml.group && !VALID_GROUPS.includes(yaml.group as typeof VALID_GROUPS[number]))
        violations.push({ file, message: `Invalid group "${yaml.group}". Must be one of: ${VALID_GROUPS.join(", ")}` })

      if (Array.isArray(yaml.related)) {
        for (const ref of yaml.related) {
          if (!resolveRef(db, ref as string))
            violations.push({ file, message: `Related ID "${ref}" does not resolve in patlib.db` })
        }
      }

      if (Array.isArray(yaml.terms)) {
        for (const ref of yaml.terms) {
          if (!resolveRef(db, ref as string))
            violations.push({ file, message: `Terms ID "${ref}" does not resolve in patlib.db` })
        }
      }

      if (Array.isArray(yaml.patterns)) {
        for (const ref of yaml.patterns) {
          if (!resolveRef(db, ref as string))
            violations.push({ file, message: `Patterns ID "${ref}" does not resolve in patlib.db` })
        }
      }

      if (yaml.id) checkDuplicate(ctx, yaml.id as string, file)
    }

    checkFilePairing(RULES_DIR, RULES_MD_DIR, violations, "(pairing)")

    db.close()
    return formatReport(files, violations, "rule YAMLs")
  },
})
