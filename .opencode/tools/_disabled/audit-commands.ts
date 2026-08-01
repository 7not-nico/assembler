// @toolclass RECG
// purity: io
// depends-on: paths, audit, parse, fs, path
import { tool } from "@opencode-ai/plugin"
import { readFileSync } from "fs"
import { join } from "path"
import { COMMANDS_YAML_DIR } from "../_lib/paths"
import { createAudit, resolveRef, checkDuplicate, formatReport, checkFilePairing } from "../_lib/audit"
import type { Violation } from "../_lib/audit"
import { parseYaml, extractFrontmatter, normalizeArray, pluralize } from "../_lib/parse"

const ID_RE = /^CMD\.[A-Z][A-Z0-9]*(\.[A-Z][A-Z0-9]*)*$/
const COMMANDS_MD_DIR = join(COMMANDS_YAML_DIR, "..")

export default tool({
  description: "Audit all .opencode/commands/yamls/ YAML files for structural and semantic compliance",
  args: {},
  async execute() {
    const ctx = createAudit(COMMANDS_YAML_DIR, ".yaml")
    const { db, violations, files } = ctx

    for (const file of files) {
      const path = join(COMMANDS_YAML_DIR, file)
      const text = readFileSync(path, "utf-8")
      const yaml = parseYaml(text)
      if (!yaml) {
        violations.push({ file, message: "Unparseable YAML" })
        continue
      }
      const name = file.replace(/\.yaml$/, "")

      if (!yaml.id) violations.push({ file, message: "Missing id" })
      if (!yaml.title) violations.push({ file, message: "Missing title" })
      if (!yaml.description) violations.push({ file, message: "Missing description" })
      if (!yaml.source) violations.push({ file, message: "Missing source" })
      if (!yaml.tags) violations.push({ file, message: "Missing tags" })

      if (yaml.id && !ID_RE.test(yaml.id as string))
        violations.push({ file, message: `Malformed ID "${yaml.id}". Must match CMD.{VERB}.{DOMAIN}` })

      if (yaml.source && yaml.source !== "assembler")
        violations.push({ file, message: `Source is "${yaml.source}", expected "assembler"` })

      const tags = normalizeArray(yaml.tags)
      if (!tags || tags.split(",").length < 3)
        violations.push({ file, message: "Tags has insufficient entries (< 3)" })

      if (yaml.id) {
        const idStr = yaml.id as string
        const verb = idStr.split(".")[1]?.toLowerCase() ?? ""
        const fileVerb = name.split("-")[0]?.toLowerCase() ?? ""
        if (verb && fileVerb && verb !== fileVerb)
          violations.push({ file, message: `ID verb "${verb}" does not match filename verb "${fileVerb}"` })
      }

      if (yaml.description) {
        const mdPath = join(COMMANDS_MD_DIR, `${name}.md`)
        try {
          const mdText = readFileSync(mdPath, "utf-8")
          const r = extractFrontmatter(mdText)
          if (r?.yaml?.description && r.yaml.description !== yaml.description)
            violations.push({ file, message: `YAML description does not match ${name}.md frontmatter description` })
        } catch { /* skip if md missing */ }
      }

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

    checkFilePairing(COMMANDS_YAML_DIR, COMMANDS_MD_DIR, violations, "(pairing)")

    db.close()
    return formatReport(files, violations, "command YAMLs")
  },
})
