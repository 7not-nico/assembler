// @toolclass RECG
// purity: io
// depends-on: paths, audit, parse, fs, path
import { tool } from "@opencode-ai/plugin"
import { readFileSync, readdirSync } from "fs"
import { join } from "path"
import { SKILLS_DIR } from "../_lib/paths"
import { createAudit, formatReport } from "../_lib/audit"
import type { Violation } from "../_lib/audit"
import { extractFrontmatter, pluralize } from "../_lib/parse"

const VALID_STATE_PROFILES = new Set(["stateless", "stateful-reader", "stateful-writer", "stateful-auditor", "hybrid"])
const VALID_TYPES = new Set(["reference", "procedure", "full"])
const NAME_RE = /^[a-z0-9]+(-[a-z0-9]+)*$/
const DESC_MAX_LENGTH = 1024
const COMPAT_MAX_LENGTH = 500

const SECTION_REQUIREMENTS: Record<string, string[]> = {
  reference: [],
  procedure: ["Procedure", "Gotchas"],
  full: ["Trigger", "Procedure", "Gotchas"],
}

export default tool({
  description: "Audit all .opencode/skills/ files for structural and semantic compliance",
  args: {},
  async execute() {
    const violations: Violation[] = []
    const seenNames = new Set<string>()

    const entries = readdirSync(SKILLS_DIR, { withFileTypes: true })
    const dirs = entries.filter(e => e.isDirectory() && !e.name.startsWith(".") && e.name !== "backups").map(e => e.name).sort()

    for (const dir of dirs) {
      const filePath = join(SKILLS_DIR, dir, "SKILL.md")
      let text: string
      try {
        text = readFileSync(filePath, "utf-8")
      } catch {
        violations.push({ file: `${dir}/SKILL.md`, message: "Missing or unreadable" })
        continue
      }

      const r = extractFrontmatter(text)
      if (!r) {
        violations.push({ file: `${dir}/SKILL.md`, message: "Missing or unparseable frontmatter YAML" })
        continue
      }
      const { body: bodyText, fm } = r

      if (!fm.name) violations.push({ file: `${dir}/SKILL.md`, message: "Missing name" })
      else if (!NAME_RE.test(fm.name as string))
        violations.push({ file: `${dir}/SKILL.md`, message: `Name "${fm.name}" must be hyphenated lowercase, may include digits` })

      if (!fm.description) violations.push({ file: `${dir}/SKILL.md`, message: "Missing description" })
      else if ((fm.description as string).length > DESC_MAX_LENGTH)
        violations.push({ file: `${dir}/SKILL.md`, message: `Description exceeds ${DESC_MAX_LENGTH} characters (${(fm.description as string).length})` })

      if (!fm["state-profile"]) violations.push({ file: `${dir}/SKILL.md`, message: "Missing state-profile" })
      else if (!VALID_STATE_PROFILES.has(fm["state-profile"] as string))
        violations.push({ file: `${dir}/SKILL.md`, message: `state-profile "${fm["state-profile"]}" must be one of: ${[...VALID_STATE_PROFILES].join(", ")}` })

      if (fm.compatibility && (fm.compatibility as string).length > COMPAT_MAX_LENGTH)
        violations.push({ file: `${dir}/SKILL.md`, message: `compatibility exceeds ${COMPAT_MAX_LENGTH} characters (${(fm.compatibility as string).length})` })

      // nexus: optional single NEX.* entity (canonical frontmatter set; related/patterns/terms/type removed)
      if (fm.nexus !== undefined && fm.nexus !== null && fm.nexus !== "") {
        const nex = String(fm.nexus)
        if (!/^NEX\.[A-Z0-9._-]+$/.test(nex))
          violations.push({ file: `${dir}/SKILL.md`, message: `nexus "${nex}" must match NEX.{SEGMENTS} format` })
      }
      if (fm.related !== undefined || fm.patterns !== undefined || fm.terms !== undefined || fm.type !== undefined)
        violations.push({ file: `${dir}/SKILL.md`, message: "Stale frontmatter field present — canonical set: name, description, state-profile, nexus" })

      if (fm.name) {
        const name = fm.name as string
        if (seenNames.has(name))
          violations.push({ file: `${dir}/SKILL.md`, message: `Duplicate name "${name}"` })
        seenNames.add(name)

        if (name !== dir)
          violations.push({ file: `${dir}/SKILL.md`, message: `Directory name "${dir}" does not match name "${name}"` })
      }

      const skillType = (fm.type as string) && VALID_TYPES.has(fm.type as string) ? (fm.type as string) : "full"
      const required = SECTION_REQUIREMENTS[skillType]
      const body = bodyText ?? ""

      for (const section of required) {
        const re = new RegExp(`^\\*\\*${section}\\*\\*`, "m")
        if (!body.match(re))
          violations.push({ file: `${dir}/SKILL.md`, message: `Missing **${section}** section (type="${skillType}" requires it)` })
      }

      const hasHashHeaders = body.match(/^## /m)
      if (hasHashHeaders) violations.push({ file: `${dir}/SKILL.md`, message: "Body contains `##` headers; use **bold** section headers only" })
    }

    if (violations.length === 0)
      return `Audited ${dirs.length} skill dirs. All OK.`

    const report = violations.map(v => `  ${v.file}: ${v.message}`).join("\n")
    return `Audited ${dirs.length} skill dirs. ${pluralize(violations.length, "violation")}:\n${report}`
  },
})
