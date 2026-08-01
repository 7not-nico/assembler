// exports: searchEntities, getEntityDetail, validateEntities, countDir
// purity: io
// depends-on: db, paths, fs, path, mcp-types, validate-file

import { Database } from "bun:sqlite"
import { readFileSync, readdirSync, existsSync } from "fs"
import { join } from "path"
import { queryAll, queryOne } from "./db"
import { PATTERNS_DIR, TERMS_DIR, SKILLS_DIR, APOLOGIAS_DIR, RULES_DIR, COMMANDS_YAML_DIR, PROTOCOLS_DIR, REFS_DIR, ABSTRACTIONS_DIR, PERSONS_DIR, ILLUSTRATIONS_DIR, MAXIMS_DIR, CONCEPTS_DIR, DEFINITIONS_DIR, TAXONOMY_DIR, ML_DIR, BASH_DIR, RUBY_DIR } from "./paths"
import { validateEntityContent } from "./validate-file"
import type { SearchRow, SearchParams, EntityDetail, ValidationResult, EntityType, IllustrationRelation } from "./mcp-types"
import { VALID_STATE_PROFILES, ID_PREFIX_TO_ENTITY_TYPE } from "./mcp-types"

const ENTITY_TABLE: Record<string, string> = {
  patterns: "patterns", terms: "terms", skills: "skills",
  rules: "rules", apologias: "apologias", commands: "commands",
  protocols: "protocols", abstractions: "abstractions",
  persons: "persons", cognitions: "cognitions",
  concepts: "concepts", definitions: "definitions",
  illustrations: "illustrations", maxims: "maxims",
  bio: "bio",
  chem: "chem",
  taxonomy: "taxonomy",
  ml: "ml",
  bash: "bash",
  ruby: "ruby",
}

export function searchEntities(db: Database, entityType: string, params: SearchParams): SearchRow[] {
  const e = entityType as EntityType

  if (e === "skills") {
    let sql = "SELECT id, title, body, skill, state_profile FROM skills"
    const conditions: string[] = []
    const p: Record<string, string | number> = {}

    if (params.state_profile) {
      conditions.push("state_profile = $state_profile")
      p.$state_profile = params.state_profile
    }
    if (params.query) {
      conditions.push("(id LIKE '%' || $query || '%' OR title LIKE '%' || $query || '%' OR body LIKE '%' || $query || '%' OR skill LIKE '%' || $query || '%')")
      p.$query = params.query
    }
    if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
    sql += " ORDER BY id LIMIT $limit OFFSET $offset"
    p.$limit = params.limit
    p.$offset = params.offset

    return queryAll(db, sql, p) as SearchRow[]
  }

  if (e === "rules" || e === "apologias" || e === "commands" || e === "protocols" || e === "abstractions" || e === "persons" || e === "illustrations" || e === "maxims" || e === "concepts" || e === "definitions" || e === "cognitions" || e === "bio" || e === "chem" || e === "taxonomy" || e === "ml" || e === "bash" || e === "ruby") {
    const table = ENTITY_TABLE[e]
    let sql = `SELECT id, title, source, tags FROM ${table}`
    const conditions: string[] = []
    const p: Record<string, string | number> = {}

    if (params.tag) {
      conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
      p.$tag = params.tag
    }
    if (params.source) {
      conditions.push("source = $source")
      p.$source = params.source
    }
    if (params.query) {
      const cols = ["id", "title", "source", "tags"]
      if (e === "commands") cols.push("description")
      if (e === "protocols") cols.push("protocol")
      if (e === "maxims") cols.push("principle")
      const likes = cols.map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
      conditions.push(`(${likes})`)
      p.$query = params.query
    }
    if (params.status && e === "protocols") {
      conditions.push("status = $status")
      p.$status = params.status
    }
    if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
    sql += " ORDER BY id LIMIT $limit OFFSET $offset"
    p.$limit = params.limit
    p.$offset = params.offset

    return queryAll(db, sql, p) as SearchRow[]
  }

  const isPatterns = e === "patterns"
  const table = isPatterns ? "patterns" : "terms"
  let cols = "id, title, source, tags"
  if (isPatterns) cols += ", summary, principle, status"
  let sql = `SELECT ${cols} FROM ${table}`
  const conditions: string[] = []
  const p: Record<string, string | number> = {}

  if (params.tag) {
    conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
    p.$tag = params.tag
  }
  if (params.source) {
    conditions.push("source = $source")
    p.$source = params.source
  }
  if (params.status && isPatterns) {
    conditions.push("status = $status")
    p.$status = params.status
  }
  if (params.query) {
    const cols2 = ["id", "title", "source", "tags"]
    if (isPatterns) cols2.push("summary", "principle")
    else cols2.push("related")
    const likes = cols2.map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
    conditions.push(`(${likes})`)
    p.$query = params.query
  }
  if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
  sql += " ORDER BY id LIMIT $limit OFFSET $offset"
  p.$limit = params.limit
  p.$offset = params.offset

  return queryAll(db, sql, p) as SearchRow[]
}

export function getEntityDetail(db: Database, entityType: string, id: string): EntityDetail {
  const e = entityType as EntityType

  if (e === "rules") {
    const row = queryOne(db, "SELECT id, title, source, tags, related FROM rules WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Rule '${id}' not found.`)
    const filePath = join(RULES_DIR, `${id.replace("RUL.", "").toLowerCase().replace(/\./g, "-")}.yaml`)
    let body: string
    try { body = readFileSync(filePath, "utf-8") } catch { body = "(file not found)" }
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "skills") {
    const row = queryOne(db, "SELECT id, title, description, body, skill, state_profile, related FROM skills WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Skill '${id}' not found.`)
    return {
      id: String(row.id), title: String(row.title),
      body: [String(row.description ?? ""), row.body ? String(row.body) : ""].filter(Boolean).join("\n\n"),
      source: null, tags: null,
      description: row.description ? String(row.description) : null,
      state_profile: row.state_profile ? String(row.state_profile) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "apologias") {
    const row = queryOne(db, "SELECT id, title, source, tags, related FROM apologias WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Apologia '${id}' not found.`)
    const filePath = join(APOLOGIAS_DIR, `${id}.md`)
    const body = readFileSync(filePath, "utf-8").replace(/^---[\s\S]*?---\s*\n?/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "commands") {
    const row = queryOne(db, "SELECT id, title, description, source, tags, related FROM commands WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Command '${id}' not found.`)
    const filePath = join(COMMANDS_YAML_DIR, `${id.replace("CMD.", "").toLowerCase().replace(/\./g, "-")}.yaml`)
    let body: string
    try { body = readFileSync(filePath, "utf-8") } catch { body = "(file not found)" }
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      description: row.description ? String(row.description) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "protocols") {
    const row = queryOne(db, "SELECT id, title, source, tags, related, protocol, enforcement, status, priority FROM protocols WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Protocol '${id}' not found.`)
    const filePath = join(PROTOCOLS_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/^---[\s\S]*?---\s*\n?/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      protocol: row.protocol ? String(row.protocol) : null,
      enforcement: row.enforcement ? String(row.enforcement) : null,
      status: row.status ? String(row.status) : null,
      priority: row.priority != null ? Number(row.priority) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "abstractions") {
    const row = queryOne(db, "SELECT id, title, source, tags, related FROM abstractions WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Abstraction '${id}' not found.`)
    const filePath = join(ABSTRACTIONS_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8").trim()
    const body = raw.replace(/\n---[\s\S]*$/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "persons") {
    const row = queryOne(db, "SELECT id, title, subtype, source, tags FROM persons WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Person '${id}' not found.`)
    const events = db.query(`
      SELECT pe.year, pe.month, pe.day, pe.location, pe.description, e.title AS event_title, e.id AS event_id
      FROM person_events pe JOIN events e ON e.id = pe.event_id
      WHERE pe.person_id = $id
      ORDER BY pe.year ASC, pe.month ASC NULLS LAST, pe.day ASC NULLS LAST
    `).all({ $id: id }) as { year: number; month: number | null; day: number | null; location: string | null; description: string | null; event_title: string; event_id: string }[]
    const filePath = join(PERSONS_DIR, `${id.toLowerCase().replace(/\./g, "-")}.md`)
    let body: string
    try {
      const raw = readFileSync(filePath, "utf-8")
      body = raw.replace(/^---[\s\S]*?---\s*\n?/, "").trim()
    } catch {
      body = "(file not found)"
    }
    const eventStr = events.map(e2 => {
      const loc = e2.location ? ` [${e2.location}]` : ""
      const label = e2.description ?? e2.event_title
      let date = String(e2.year)
      if (e2.month != null) date += `-${String(e2.month).padStart(2, "0")}`
      if (e2.day != null) date += `-${String(e2.day).padStart(2, "0")}`
      return `  ${date} — ${label}${loc}`
    }).join("\n")
    body = body + (eventStr ? `\n\n## Events\n${eventStr}` : "")
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      description: row.subtype ? String(row.subtype) : null,
    }
  }

  if (e === "illustrations") {
    const row = queryOne(db, "SELECT id, title, summary, source, tags, related FROM illustrations WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Illustration '${id}' not found.`)
    const filePath = join(ILLUSTRATIONS_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/^---[\s\S]*?---\s*\n?/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      summary: row.summary ? String(row.summary) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "maxims") {
    const row = queryOne(db, "SELECT id, title, source, tags, related, summary, principle, enforcement, status, priority FROM maxims WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Maxim '${id}' not found.`)
    const filePath = join(MAXIMS_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/^---[\s\S]*?---\s*\n?/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      summary: row.summary ? String(row.summary) : null,
      principle: row.principle ? String(row.principle) : null,
      enforcement: row.enforcement ? String(row.enforcement) : null,
      status: row.status ? String(row.status) : null,
      priority: row.priority != null ? Number(row.priority) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  const isPatterns = e === "patterns"
  const table = isPatterns ? "patterns" : "terms"
  let cols = "id, title, source, tags"
  if (isPatterns) cols += ", summary, principle, enforcement, status, priority"
  else cols += ", related"
  const dirs: Record<string, string> = { patterns: PATTERNS_DIR, terms: TERMS_DIR, concepts: CONCEPTS_DIR, definitions: DEFINITIONS_DIR, cognitions: CONCEPTS_DIR }

  if (e === "concepts") {
    const row = queryOne(db, "SELECT id, title, source, tags, related FROM concepts WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Concept '${id}' not found.`)
    const filePath = join(CONCEPTS_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/\n---[\s\S]*$/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "definitions") {
    const row = queryOne(db, "SELECT id, title, source, tags, related FROM definitions WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Definition '${id}' not found.`)
    const filePath = join(DEFINITIONS_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/\n---[\s\S]*$/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "taxonomy") {
    const row = queryOne(db, "SELECT id, title, source, rank, tags, related FROM taxonomy WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Taxon '${id}' not found.`)
    const filePath = join(TAXONOMY_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/\n---[\s\S]*$/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
      description: row.rank ? String(row.rank) : null,
    }
  }

  if (e === "ml") {
    const row = queryOne(db, "SELECT id, title, source, type, paradigm, subfield, category, tags, related FROM ml WHERE id = $id", { $id: id })
    if (!row) throw new Error(`ML entity '${id}' not found.`)
    const filePath = join(ML_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/\n---[\s\S]*$/, "").trim()
    let detailBody = body
    const extra: string[] = []
    if (row.type) extra.push(`**Type:** ${row.type}`)
    if (row.paradigm) extra.push(`**Paradigm:** ${row.paradigm}`)
    if (row.subfield) extra.push(`**Subfield:** ${row.subfield}`)
    if (row.category) extra.push(`**Category:** ${row.category}`)
    if (extra.length > 0) detailBody = body + "\n\n" + extra.join("\n")
    return {
      id: String(row.id), title: String(row.title), body: detailBody,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "bash") {
    const row = queryOne(db, "SELECT id, title, source, tags, related FROM bash WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Bash entity '${id}' not found.`)
    const filePath = join(BASH_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/\n---[\s\S]*$/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  if (e === "ruby") {
    const row = queryOne(db, "SELECT id, title, source, tags, related FROM ruby WHERE id = $id", { $id: id })
    if (!row) throw new Error(`Ruby entity '${id}' not found.`)
    const filePath = join(RUBY_DIR, `${id}.md`)
    const raw = readFileSync(filePath, "utf-8")
    const body = raw.replace(/\n---[\s\S]*$/, "").trim()
    return {
      id: String(row.id), title: String(row.title), body,
      source: row.source ? String(row.source) : null,
      tags: row.tags ? String(row.tags) : null,
      related: row.related ? String(row.related) : null,
    }
  }

  const row = queryOne(db, `SELECT ${cols} FROM ${table} WHERE id = $id`, { $id: id })
  if (!row) throw new Error(`${isPatterns ? "Pattern" : "Term"} '${id}' not found.`)
  const filePath = join(dirs[e], `${id}.md`)
  let body: string
  try {
    const raw = readFileSync(filePath, "utf-8")
    body = raw.replace(/^---[\s\S]*?---\s*\n?/, "").trim()
  } catch {
    body = "(file not found)"
  }

  const detail: EntityDetail = {
    id: String(row.id), title: String(row.title), body,
    source: row.source ? String(row.source) : null,
    tags: row.tags ? String(row.tags) : null,
  }
  if (isPatterns) {
    detail.summary = row.summary ? String(row.summary) : null
    detail.principle = row.principle ? String(row.principle) : null
    detail.enforcement = row.enforcement ? String(row.enforcement) : null
    detail.status = row.status ? String(row.status) : null
    detail.priority = row.priority != null ? Number(row.priority) : null
  } else {
    detail.related = row.related ? String(row.related) : null
  }
  return detail
}

export function findIllustrations(
  db: Database,
  params: {
    entity_id?: string
    illustration_id?: string
    entity_type?: string
    limit: number
    offset: number
  }
): IllustrationRelation[] {
  const { entity_id, illustration_id, entity_type } = params
  let sql = `
    SELECT ie.illustration_id, ie.entity_id, ie.entity_type, i.title AS illustration_title
    FROM illustration_entities ie
    JOIN illustrations i ON i.id = ie.illustration_id
  `
  const conditions: string[] = []
  const bindings: Record<string, string | number> = {}

  if (illustration_id) {
    conditions.push("ie.illustration_id = $illustration_id")
    bindings.$illustration_id = illustration_id
  }

  if (entity_id) {
    conditions.push("ie.entity_id = $entity_id")
    bindings.$entity_id = entity_id
  }

  if (entity_type) {
    conditions.push("ie.entity_type = $entity_type")
    bindings.$entity_type = entity_type
  }

  if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
  sql += " ORDER BY ie.illustration_id, ie.entity_id LIMIT $limit OFFSET $offset"
  bindings.$limit = params.limit
  bindings.$offset = params.offset

  const rows = queryAll(db, sql, bindings) as Array<{ illustration_id: string; entity_id: string; entity_type: string; illustration_title: string }>

  const results: IllustrationRelation[] = []

  for (const row of rows) {
    const table = ENTITY_TABLE[row.entity_type]
    if (!table) continue

    const entityRow = queryOne(db, `SELECT title FROM ${table} WHERE id = $id`, { $id: row.entity_id })
    if (entityRow) {
      results.push({
        illustration_id: row.illustration_id,
        illustration_title: row.illustration_title,
        entity_id: row.entity_id,
        entity_title: String(entityRow.title),
        entity_type: row.entity_type,
      })
    }
  }

  return results
}

export function validateEntities(db: Database): ValidationResult {
  const violations: string[] = []

  const validateFile = (filePath: string, type: "pattern" | "term" | "skill" | "apologia" | "protocol" | "ref" | "person" | "illustration" | "maxim" | "ml" | "bash" | "ruby") => {
    const text = readFileSync(filePath, "utf-8")
    const vs = validateEntityContent(text, type, VALID_STATE_PROFILES)
    for (const v of vs) violations.push(`${filePath}: ${v}`)
  }

  const valDir = (dir: string, type: "pattern" | "term" | "skill" | "apologia" | "protocol" | "ref" | "person" | "illustration" | "maxim" | "ml" | "bash" | "ruby") => {
    for (const f of readdirSync(dir).filter(f => f.endsWith(".md")).sort()) {
      validateFile(join(dir, f), type)
    }
  }

  const countDir = (dir: string) => readdirSync(dir).filter(f => f.endsWith(".md")).length

  valDir(PATTERNS_DIR, "pattern")
  valDir(TERMS_DIR, "term")
  valDir(APOLOGIAS_DIR, "apologia")
  valDir(PROTOCOLS_DIR, "protocol")
  valDir(REFS_DIR, "ref")
  valDir(PERSONS_DIR, "person")
  valDir(ILLUSTRATIONS_DIR, "illustration")
  valDir(MAXIMS_DIR, "maxim")
  valDir(ML_DIR, "ml")
  valDir(BASH_DIR, "bash")
  valDir(RUBY_DIR, "ruby")

  const skillDirs = readdirSync(SKILLS_DIR, { withFileTypes: true }).filter(e => e.isDirectory()).map(e => e.name).sort()
  for (const d of skillDirs) {
    const fp = join(SKILLS_DIR, d, "SKILL.md")
    if (existsSync(fp)) validateFile(fp, "skill")
  }

  return {
    counts: {
      patterns: countDir(PATTERNS_DIR),
      terms: countDir(TERMS_DIR),
      skills: skillDirs.length,
      apologias: countDir(APOLOGIAS_DIR),
      protocols: countDir(PROTOCOLS_DIR),
      refs: countDir(REFS_DIR),
      persons: countDir(PERSONS_DIR),
      illustrations: countDir(ILLUSTRATIONS_DIR),
      maxims: countDir(MAXIMS_DIR),
    },
    violations,
  }
}
