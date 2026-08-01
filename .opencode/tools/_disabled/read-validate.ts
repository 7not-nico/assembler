// @toolclass RECG
// purity: io
// depends-on: paths, errors, parse, fs, validate-file, mcp-types
import { tool } from "@opencode-ai/plugin"
import { readFileSync, readdirSync } from "fs"
import { join } from "path"
import { PATTERNS_DIR, TERMS_DIR, SKILLS_DIR, APOLOGIAS_DIR, PROTOCOLS_DIR, PERSONS_DIR, MAXIMS_DIR, NEXUS_DIR } from "../_lib/paths"
import { crashOnError } from "../_lib/errors"
import { pluralize } from "../_lib/parse"
import { validateEntityContent } from "../_lib/validate-file"
import { VALID_STATE_PROFILES } from "../_lib/mcp-types"

function collectViolations(filePath: string, violations: string[], type: "pattern" | "term" | "skill" | "apologia" | "protocol" | "nexus" | "person" | "maxim") {
  const text = readFileSync(filePath, "utf-8")
  const vs = validateEntityContent(text, type, VALID_STATE_PROFILES)
  for (const v of vs) violations.push(`${filePath}: ${v}`)
}

  export default tool({
  description: "Validate all pattern, term, skill, apologia, protocol, person, and maxim .md files for structural correctness",
  args: {},
  async execute() {
    crashOnError()

    const allViolations: string[] = []

    const patternFiles = readdirSync(PATTERNS_DIR).filter(f => f.endsWith(".md")).sort()
    const termFiles = readdirSync(TERMS_DIR).filter(f => f.endsWith(".md")).sort()
    const skillDirs = readdirSync(SKILLS_DIR, { withFileTypes: true }).filter(e => e.isDirectory()).map(e => e.name).sort()
    const skillFiles = skillDirs.map(d => join(SKILLS_DIR, d, "SKILL.md")).filter(f => { try { readFileSync(f); return true } catch { return false } })
    const apoFiles = readdirSync(APOLOGIAS_DIR).filter(f => f.endsWith(".md")).sort()
    const protFiles = readdirSync(PROTOCOLS_DIR).filter(f => f.endsWith(".md")).sort()
    const personFiles = readdirSync(PERSONS_DIR).filter(f => f.endsWith(".md")).sort()
    const maximFiles = readdirSync(MAXIMS_DIR).filter(f => f.endsWith(".md")).sort()
    const nexusFiles = readdirSync(NEXUS_DIR).filter(f => f.endsWith(".md")).sort()

    for (const file of patternFiles) {
      collectViolations(join(PATTERNS_DIR, file), allViolations, "pattern")
    }

    for (const file of termFiles) {
      collectViolations(join(TERMS_DIR, file), allViolations, "term")
    }

    for (const file of skillFiles) {
      collectViolations(file, allViolations, "skill")
    }

    for (const file of apoFiles) {
      collectViolations(join(APOLOGIAS_DIR, file), allViolations, "apologia")
    }

    for (const file of protFiles) {
      collectViolations(join(PROTOCOLS_DIR, file), allViolations, "protocol")
    }

    for (const file of personFiles) {
      collectViolations(join(PERSONS_DIR, file), allViolations, "person")
    }

    for (const file of maximFiles) {
      collectViolations(join(MAXIMS_DIR, file), allViolations, "maxim")
    }

    for (const file of nexusFiles) {
      collectViolations(join(NEXUS_DIR, file), allViolations, "nexus")
    }

    if (allViolations.length > 0) {
      throw new Error(allViolations.join("\n"))
    }

    const parts = [
      pluralize(patternFiles.length, "pattern"),
      pluralize(termFiles.length, "term"),
      pluralize(skillFiles.length, "skill"),
      pluralize(apoFiles.length, "apologia"),
      pluralize(protFiles.length, "protocol"),
      pluralize(personFiles.length, "person"),
      pluralize(maximFiles.length, "maxim"),
      pluralize(nexusFiles.length, "nexus"),
    ]
    return `Validated ${parts.join(", ")}. All OK.`
  },
})
