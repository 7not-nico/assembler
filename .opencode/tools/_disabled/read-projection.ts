// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initDB, queryOne } from "../_lib/db"
import { crashOnError } from "../_lib/errors"
import { readFileSync } from "fs"
import { join } from "path"
import { FRONTMATTER_RE, BACKMATTER_RE } from "../_lib/parse"
import { PATTERNS_DIR, TERMS_DIR, SKILLS_DIR, RULES_DIR, APOLOGIAS_DIR, COMMANDS_YAML_DIR, ABSTRACTIONS_DIR, PROTOCOLS_DIR, LINGUISTICS_DIR, PERSONS_DIR, ILLUSTRATIONS_DIR, MAXIMS_DIR, NEXUS_DIR, SEPARATOR } from "../_lib/paths"

function fetchRefs(db: any, st: string, id: string) {
  const terms = db.query("SELECT term_id FROM entity_terms WHERE source_type = $st AND source_id = $id ORDER BY term_id").all({ $st: st, $id: id }) as { term_id: string }[]
  const patterns = db.query("SELECT pattern_id FROM entity_patterns WHERE source_type = $st AND source_id = $id ORDER BY pattern_id").all({ $st: st, $id: id }) as { pattern_id: string }[]
  return { terms: terms.map(r => r.term_id), patterns: patterns.map(r => r.pattern_id) }
}

export default tool({
  description: "Show full details for a term, pattern, skill, rule, apologia, command, protocol, abstraction, linguistics, person, illustration, or maxim entry by ID",
  args: {
    id: tool.schema.string().describe("Entity ID (e.g. MAX.DRY or TERM.OPENCODE or SKL.AUDIT.PATTERN or APO.SKILL.DERIVATION)"),
    type: tool.schema.string().optional().describe("Entity type: terms (default), patterns, skills, rules, apologias, commands, protocols, abstractions, linguistics, persons, illustrations, or maxims"),
  },
  async execute(args) {
    crashOnError()
    const db = initDB()

    if (args.type === "rules") {
      const row = queryOne(db, "SELECT id, title, source, tags, related, created, modified FROM rules WHERE id = $id", { $id: args.id })
      const refs = row ? fetchRefs(db, "rule", row.id as string) : { terms: [], patterns: [] }
      db.close()
      if (!row) throw new Error(`Rule '${args.id}' not found.`)
      const filePath = join(RULES_DIR, `${args.id.replace("RUL.", "").toLowerCase().replace(/\./g, "-")}.yaml`)
      let body: string
      try {
        body = readFileSync(filePath, "utf-8")
      } catch {
        body = "(file not found)"
      }
      let out = `\n${row.id} ${row.title}\n`
      out += SEPARATOR + "\n\n"
      out += `${body}\n\n`
      out += `  Source:     ${row.source ?? "-"}\n`
      if (row.tags) out += `  Tags:       ${row.tags}\n`
      if (row.related) out += `  Related:    ${row.related}\n`
      if (refs.terms.length) out += `  Terms:      ${refs.terms.join(",")}\n`
      if (refs.patterns.length) out += `  Patterns:   ${refs.patterns.join(",")}\n`
      out += `  Created:    ${row.created}\n`
      out += `  Modified:   ${row.modified}\n`
      return out
    }

    if (args.type === "skills") {
      const row = queryOne(db, "SELECT id, title, description, trigger, procedure, gotchas, rules, body, skill, state_profile, related FROM skills WHERE id = $id", { $id: args.id })
      const refs = row ? fetchRefs(db, "skill", row.id as string) : { terms: [], patterns: [] }
      db.close()

      if (!row) throw new Error(`Skill '${args.id}' not found.`)

      const sections: [string, string][] = [
        ["Trigger", row.trigger as string],
        ["Procedure", row.procedure as string],
        ["Gotchas", row.gotchas as string],
        ["Rules", row.rules as string],
      ]

      let out = `\n${row.id} ${row.title}\n`
      out += SEPARATOR + "\n\n"
      out += `${row.description}\n\n`

      for (const [name, content] of sections) {
        if (content) {
          out += `**${name}** — ${content}\n\n`
        }
      }

      if (row.body) {
        out += `${row.body}\n\n`
      }

      out += `  Skill:       ${row.skill}\n`
      out += `  State profile: ${row.state_profile}\n`
      const rel = row.related as string | null
      if (rel) out += `  Related:     ${rel}\n`
      if (refs.terms.length) out += `  Terms:       ${refs.terms.join(",")}\n`
      if (refs.patterns.length) out += `  Patterns:    ${refs.patterns.join(",")}\n`
      return out
    }

    if (args.type === "apologias") {
      const row = queryOne(db, "SELECT id, title, source, tags, related, created, modified FROM apologias WHERE id = $id", { $id: args.id })
      db.close()
      if (!row) throw new Error(`Apologia '${args.id}' not found.`)
      const filePath = join(APOLOGIAS_DIR, `${args.id}.md`)
      const fileText = readFileSync(filePath, "utf-8")
      const m = fileText.match(FRONTMATTER_RE)
      const body = m ? fileText.slice(m[0].length).trim() : fileText
      let out = `\n${row.id} ${row.title}\n`
      out += SEPARATOR + "\n\n"
      out += `${body}\n\n`
      out += `  Source:     ${row.source ?? "-"}\n`
      if (row.tags) out += `  Tags:       ${row.tags}\n`
      if (row.related) out += `  Related:    ${row.related}\n`
      out += `  Created:    ${row.created}\n`
      out += `  Modified:   ${row.modified}\n`
      return out
    }

    if (args.type === "commands") {
      const row = queryOne(db, "SELECT id, title, description, source, tags, related, created, modified FROM commands WHERE id = $id", { $id: args.id })
      const refs = row ? fetchRefs(db, "command", row.id as string) : { terms: [], patterns: [] }
      db.close()
      if (!row) throw new Error(`Command '${args.id}' not found.`)
      const filePath = join(COMMANDS_YAML_DIR, `${args.id.replace("CMD.", "").toLowerCase().replace(/\./g, "-")}.yaml`)
      let body: string
      try {
        body = readFileSync(filePath, "utf-8")
      } catch {
        body = "(file not found)"
      }
      let out = `\n${row.id} ${row.title}\n`
      out += SEPARATOR + "\n\n"
      out += `${body}\n\n`
      out += `  Description: ${row.description ?? "-"}\n`
      out += `  Source:     ${row.source ?? "-"}\n`
      if (row.tags) out += `  Tags:       ${row.tags}\n`
      if (row.related) out += `  Related:    ${row.related}\n`
      if (refs.terms.length) out += `  Terms:      ${refs.terms.join(",")}\n`
      if (refs.patterns.length) out += `  Patterns:   ${refs.patterns.join(",")}\n`
      out += `  Created:    ${row.created}\n`
      out += `  Modified:   ${row.modified}\n`
      return out
    }

  if (args.type === "protocols") {
    const row = queryOne(db, "SELECT id, title, source, tags, related, protocol, enforcement, status, priority, created, modified FROM protocols WHERE id = $id", { $id: args.id })
    const refs = row ? fetchRefs(db, "protocol", row.id as string) : { terms: [], patterns: [] }
    db.close()
    if (!row) throw new Error(`Protocol '${args.id}' not found.`)
    const filePath = join(PROTOCOLS_DIR, `${args.id}.md`)
    const fileText = readFileSync(filePath, "utf-8")
    const m = fileText.match(FRONTMATTER_RE)
    const body = m ? fileText.slice(m[0].length).trim() : fileText
    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`
    out += `  Protocol:   ${row.protocol ?? "-"}\n`
    out += `  Enforcement: ${row.enforcement ?? "-"}\n`
    out += `  Status:     ${row.status ?? "-"}\n`
    out += `  Priority:   ${row.priority ?? "-"}\n`
    out += `  Source:     ${row.source ?? "-"}\n`
    if (row.tags) out += `  Tags:       ${row.tags}\n`
    if (row.related) out += `  Related:    ${row.related}\n`
    if (refs.terms.length) out += `  Terms:      ${refs.terms.join(",")}\n`
    if (refs.patterns.length) out += `  Patterns:   ${refs.patterns.join(",")}\n`
    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`
    return out
  }

  if (args.type === "abstractions") {
    const row = queryOne(db, "SELECT id, title, source, tags, related, reference, created, modified FROM abstractions WHERE id = $id", { $id: args.id })
    db.close()
    if (!row) throw new Error(`Abstraction '${args.id}' not found.`)
    const filePath = join(ABSTRACTIONS_DIR, `${args.id}.md`)
    const fileText = readFileSync(filePath, "utf-8")
    const trimmed = fileText.trim()
    const m = trimmed.match(BACKMATTER_RE)
    const body = m ? trimmed.slice(0, m.index).trim() : trimmed
    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`
    out += `  Source:     ${row.source ?? "-"}\n`
    if (row.tags) out += `  Tags:       ${row.tags}\n`
    if (row.related) out += `  Related:    ${row.related}\n`
    if (row.reference) {
      out += `  Reference:\n`
      const refs = JSON.parse(row.reference as string) as string[]
      for (const url of refs) {
        out += `    - ${url}\n`
      }
    }
    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`
    return out
  }

  if (args.type === "linguistics") {
    const row = queryOne(db, "SELECT id, title, source, tags, related, reference, created, modified FROM linguistics WHERE id = $id", { $id: args.id })
    db.close()
    if (!row) throw new Error(`Linguistics entry '${args.id}' not found.`)
    const filePath = join(LINGUISTICS_DIR, `${args.id}.md`)
    const fileText = readFileSync(filePath, "utf-8")
    const trimmed = fileText.trim()
    const m = trimmed.match(BACKMATTER_RE)
    const body = m ? trimmed.slice(0, m.index).trim() : trimmed
    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`
    out += `  Source:     ${row.source ?? "-"}\n`
    if (row.tags) out += `  Tags:       ${row.tags}\n`
    if (row.related) out += `  Related:    ${row.related}\n`
    if (row.reference) {
      out += `  Reference:\n`
      const refs = JSON.parse(row.reference as string) as string[]
      for (const url of refs) {
        out += `    - ${url}\n`
      }
    }
    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`
    return out
  }

  if (args.type === "persons") {
    const row = queryOne(db, "SELECT id, title, subtype, source, tags, created, modified FROM persons WHERE id = $id", { $id: args.id })
    if (!row) throw new Error(`Person '${args.id}' not found.`)
    const events = db.query(`
      SELECT pe.year, pe.month, pe.day, pe.location, pe.description, e.title AS event_title, e.id AS event_id
      FROM person_events pe JOIN events e ON e.id = pe.event_id
      WHERE pe.person_id = $id
      ORDER BY pe.year ASC, pe.month ASC NULLS LAST, pe.day ASC NULLS LAST
    `).all({ $id: args.id }) as { year: number; month: number | null; day: number | null; location: string | null; description: string | null; event_title: string; event_id: string }[]
    db.close()
    const filePath = join(PERSONS_DIR, `${args.id.toLowerCase().replace(/\./g, "-")}.md`)
    let fileText: string
    try { fileText = readFileSync(filePath, "utf-8") } catch { fileText = "" }
    const m = fileText.match(FRONTMATTER_RE)
    const body = m ? fileText.slice(m[0].length).trim() : fileText
    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`
    if (events.length > 0) {
      out += `## Events\n`
      for (const ev of events) {
        const loc = ev.location ? ` [${ev.location}]` : ""
        const label = ev.description ?? ev.event_title
        let date = String(ev.year)
        if (ev.month != null) date += `-${String(ev.month).padStart(2, "0")}`
        if (ev.day != null) date += `-${String(ev.day).padStart(2, "0")}`
        out += `  ${date} — ${label}${loc}\n`
      }
      out += "\n"
    }
    out += `  Subtype:    ${row.subtype ?? "-"}\n`
    out += `  Source:     ${row.source ?? "-"}\n`
    if (row.tags) out += `  Tags:       ${row.tags}\n`
    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`
    return out
  }

  if (args.type === "illustrations") {
    const row = queryOne(db, "SELECT id, title, summary, illustration, illustrates, source, tags, related, created, modified FROM illustrations WHERE id = $id", { $id: args.id })
    db.close()
    if (!row) throw new Error(`Illustration '${args.id}' not found.`)
    const filePath = join(ILLUSTRATIONS_DIR, `${args.id}.md`)
    const fileText = readFileSync(filePath, "utf-8")
    const m = fileText.match(FRONTMATTER_RE)
    const body = m ? fileText.slice(m[0].length).trim() : fileText
    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`
    out += `  Summary:    ${row.summary ?? "-"}\n`
    out += `  Illustration: ${row.illustration ?? "-"}\n`
    out += `  Illustrates: ${row.illustrates ?? "-"}\n`
    out += `  Source:     ${row.source ?? "-"}\n`
    if (row.tags) out += `  Tags:       ${row.tags}\n`
    if (row.related) out += `  Related:    ${row.related}\n`
    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`
    return out
  }

  if (args.type === "nexus") {
    const row = queryOne(db, "SELECT id, title, source, tags, related, summary, nexus, composition, status, priority, created, modified FROM nexus WHERE id = $id", { $id: args.id })
    db.close()
    if (!row) throw new Error(`Nexus '${args.id}' not found.`)
    const filePath = join(NEXUS_DIR, `${args.id}.md`)
    const fileText = readFileSync(filePath, "utf-8")
    const m = fileText.match(FRONTMATTER_RE)
    const body = m ? fileText.slice(m[0].length).trim() : fileText
    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`
    out += `  Summary:    ${row.summary ?? "-"}\n`
    out += `  Nexus:      ${row.nexus ?? "-"}\n`
    out += `  Composition: ${row.composition ?? "-"}\n`
    out += `  Status:     ${row.status ?? "-"}\n`
    out += `  Priority:   ${row.priority ?? "-"}\n`
    out += `  Source:     ${row.source ?? "-"}\n`
    if (row.tags) out += `  Tags:       ${row.tags}\n`
    if (row.related) out += `  Related:    ${row.related}\n`
    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`
    return out
  }

  if (args.type === "maxims") {
    const row = queryOne(db, "SELECT id, title, source, tags, related, summary, principle, enforcement, status, priority, created, modified FROM maxims WHERE id = $id", { $id: args.id })
    db.close()
    if (!row) throw new Error(`Maxim '${args.id}' not found.`)
    const filePath = join(MAXIMS_DIR, `${args.id}.md`)
    const fileText = readFileSync(filePath, "utf-8")
    const m = fileText.match(FRONTMATTER_RE)
    const body = m ? fileText.slice(m[0].length).trim() : fileText
    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`
    out += `  Summary:    ${row.summary ?? "-"}\n`
    out += `  Principle:  ${row.principle ?? "-"}\n`
    out += `  Enforcement: ${row.enforcement ?? "-"}\n`
    out += `  Status:     ${row.status ?? "-"}\n`
    out += `  Priority:   ${row.priority ?? "-"}\n`
    out += `  Source:     ${row.source ?? "-"}\n`
    if (row.tags) out += `  Tags:       ${row.tags}\n`
    if (row.related) out += `  Related:    ${row.related}\n`
    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`
    return out
  }

    const entity = args.type === "patterns" ? "patterns" : "terms"
    let cols = "id, title, source, tags, created, modified"
    if (entity === "patterns") cols += ", summary, principle, enforcement, status, priority"
    if (entity === "terms") cols += ", related, reference"
    const row = queryOne(db, `SELECT ${cols} FROM ${entity} WHERE id = $id`, { $id: args.id })
    const refs = row ? fetchRefs(db, entity === "patterns" ? "pattern" : "term", row.id as string) : { terms: [], patterns: [] }
    db.close()

    if (!row) {
      throw new Error(`${entity === "patterns" ? "Pattern" : "Term"} '${args.id}' not found.`)
    }

    const dirs: Record<string, string> = { patterns: PATTERNS_DIR, terms: TERMS_DIR }
    const filePath = join(dirs[entity], `${args.id}.md`)
    const fileText = readFileSync(filePath, "utf-8")

    let body: string
    if (entity === "patterns") {
      const m = fileText.match(FRONTMATTER_RE)
      body = m ? fileText.slice(m[0].length).trim() : fileText
    } else {
      const trimmed = fileText.trim()
      const m = trimmed.match(BACKMATTER_RE)
      body = m ? trimmed.slice(0, m.index).trim() : trimmed
    }

    let out = `\n${row.id} ${row.title}\n`
    out += SEPARATOR + "\n\n"
    out += `${body}\n\n`

    if (entity === "patterns") {
      if (row.summary) out += `  Summary:    ${row.summary}\n`
      if (row.principle) out += `  Principle:  ${row.principle}\n`
      if (row.enforcement) out += `  Enforcement: ${row.enforcement}\n`
      if (row.status) out += `  Status:     ${row.status}\n`
      if (row.priority != null) out += `  Priority:   ${row.priority}\n`
    }

    out += `  Source:     ${row.source ?? "-"}\n`

    if (row.tags) out += `  Tags:       ${row.tags}\n`

    if (entity === "terms") {
      if (row.related) out += `  Related:    ${row.related}\n`
      if (row.reference) {
        out += `  Reference:\n`
        const refs = JSON.parse(row.reference as string) as string[]
        for (const url of refs) {
          out += `    - ${url}\n`
        }
      }
    }

    if (refs.terms.length) out += `  Terms:      ${refs.terms.join(",")}\n`
    if (refs.patterns.length) out += `  Patterns:   ${refs.patterns.join(",")}\n`

    out += `  Created:    ${row.created}\n`
    out += `  Modified:   ${row.modified}\n`

    return out
  },
})
