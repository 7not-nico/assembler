// exports: parsePatternFile, parseMaximFile, parseTermFile, parseBioFile, parseChemFile, parseTaxFile, parseMlFile, parseBashFile, parseRubyFile, parseCognitionFile, parseConceptFile, parseDefinitionFile, parseProtocolFile, parseRefFile, parseAbstractionFile, parseApologiaFile, parseManifestFile, parseRuleFile, parseCommandFile, parseIllustrationFile, parsePreceptFile, syncSkills, syncJunction, syncRules, syncCommands, syncIllustrations, syncAll
// purity: io
// depends-on: paths, parse, fs, path, mcp-types

import { readFileSync, readdirSync, statSync, existsSync } from "fs"
import { dirname, join } from "path"
import { PATTERNS_DIR, TERMS_DIR, BIO_DIR, CHEM_DIR, TAXONOMY_DIR, ML_DIR, BASH_DIR, RUBY_DIR, COGNITIONS_DIR, CONCEPTS_DIR, DEFINITIONS_DIR, SKILLS_DIR, APOLOGIAS_DIR, RULES_DIR, COMMANDS_YAML_DIR, ABSTRACTIONS_DIR, PROTOCOLS_DIR, REFS_DIR, LINGUISTICS_DIR, PERSONS_DIR, ILLUSTRATIONS_DIR, MAXIMS_DIR, PRECEPTS_DIR, NEXUS_DIR, IDENTITIES_DIR, MANIFESTS_DIR, SPECIFICATIONS_DIR } from "./paths"
import { extractFrontmatter, extractBackmatter, parseYaml, normalizeArray, normalizeReferences, pluralize } from "./parse"
import { ID_PREFIX_TO_ENTITY_TYPE } from "./mcp-types"
import { detectPersonStaleness } from "./validate-persons"

export function parsePatternFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    source: fm.source ? String(fm.source) : null,
    summary: fm.summary ? String(fm.summary) : null,
    morphism: fm.morphism ? String(fm.morphism) : null,
    enforcement: fm.enforcement ? String(fm.enforcement) : null,
    status: fm.status ? String(fm.status) : "draft",
    priority: fm.priority != null ? Number(fm.priority) : 5,
    tags: normalizeArray(fm.tags),
    terms: normalizeArray(fm.terms),
    patterns: normalizeArray(fm.patterns),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseNexusFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    source: fm.source ? String(fm.source) : null,
    summary: fm.summary ? String(fm.summary) : null,
    nexus: fm.nexus ? String(fm.nexus) : null,
    composition: fm.composition ? String(fm.composition) : null,
    status: fm.status ? String(fm.status) : "draft",
    priority: fm.priority != null ? Number(fm.priority) : 5,
    tags: normalizeArray(fm.tags),
    related: normalizeArray(fm.related),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseMaximFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    source: fm.source ? String(fm.source) : null,
    summary: fm.summary ? String(fm.summary) : null,
    principle: fm.principle ? String(fm.principle) : null,
    enforcement: fm.enforcement ? String(fm.enforcement) : null,
    status: fm.status ? String(fm.status) : "active",
    priority: fm.priority != null ? Number(fm.priority) : 2,
    tags: normalizeArray(fm.tags),
    related: normalizeArray(fm.related),
    terms: normalizeArray(fm.terms),
    patterns: normalizeArray(fm.patterns),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseTermFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    terms: normalizeArray(bm.terms),
    patterns: normalizeArray(bm.patterns),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseBioFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseChemFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseTaxFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    rank: bm.rank ? String(bm.rank) : null,
    precedes: normalizeArray(bm.precedes),
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseMlFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    type: bm.type ? String(bm.type) : null,
    paradigm: bm.paradigm ? String(bm.paradigm) : null,
    subfield: bm.subfield ? String(bm.subfield) : null,
    category: bm.category ? String(bm.category) : null,
    precedes: normalizeArray(bm.precedes),
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseBashFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    precedes: normalizeArray(bm.precedes),
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseRubyFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    precedes: normalizeArray(bm.precedes),
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseCognitionFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseConceptFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseDefinitionFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseIdentityFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseSpecificationFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    summary: bm.summary ? String(bm.summary) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parsePreceptFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    source: fm.source ? String(fm.source) : null,
    summary: fm.summary ? String(fm.summary) : null,
    precept: fm.precept ? String(fm.precept) : null,
    enforcement: fm.enforcement ? String(fm.enforcement) : null,
    status: fm.status ? String(fm.status) : "active",
    priority: fm.priority != null ? Number(fm.priority) : 3,
    tags: normalizeArray(fm.tags),
    related: normalizeArray(fm.related),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseManifestFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    tags: normalizeArray(bm.tags),
    related: normalizeArray(bm.related),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseProtocolFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    source: fm.source ? String(fm.source) : null,
    protocol: fm.protocol ? String(fm.protocol) : null,
    enforcement: fm.enforcement ? String(fm.enforcement) : null,
    status: fm.status ? String(fm.status) : "active",
    priority: fm.priority != null ? Number(fm.priority) : 3,
    tags: normalizeArray(fm.tags),
    related: normalizeArray(fm.related),
    terms: normalizeArray(fm.terms),
    patterns: normalizeArray(fm.patterns),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseRefFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    source: fm.source ? String(fm.source) : null,
    ref_text: fm.ref ? String(fm.ref) : null,
    tags: normalizeArray(fm.tags),
    related: normalizeArray(fm.related),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseIllustrationFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    summary: fm.summary ? String(fm.summary) : null,
    illustration: fm.illustration ? String(fm.illustration) : null,
    illustrates: normalizeArray(fm.illustrates),
    source: fm.source ? String(fm.source) : null,
    related: normalizeArray(fm.related),
    tags: normalizeArray(fm.tags),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseAbstractionFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseLinguisticsFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8").trim()
  const r = extractBackmatter(text)
  if (!r) throw new Error(`Missing backmatter: ${filePath}`)
  const { body, bm } = r
  return {
    id: String(bm.id ?? ""),
    title: String(bm.title ?? ""),
    body,
    source: bm.source ? String(bm.source) : null,
    related: normalizeArray(bm.related),
    tags: normalizeArray(bm.tags),
    reference: normalizeReferences(bm.reference),
    created: bm.created ? String(bm.created) : new Date().toISOString(),
    modified: bm.modified ? String(bm.modified) : new Date().toISOString(),
  }
}

export function parseApologiaFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    source: fm.source ? String(fm.source) : null,
    tags: normalizeArray(fm.tags),
    related: normalizeArray(fm.related),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function parseRuleFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const yaml = parseYaml(text) ?? {}
  return {
    id: String(yaml.id ?? ""),
    title: String(yaml.title ?? ""),
    source: yaml.source ? String(yaml.source) : null,
    tags: normalizeArray(yaml.tags),
    related: normalizeArray(yaml.related),
    terms: normalizeArray(yaml.terms),
    patterns: normalizeArray(yaml.patterns),
    created: yaml.created ? String(yaml.created) : new Date().toISOString(),
    modified: yaml.modified ? String(yaml.modified) : new Date().toISOString(),
  }
}

const RULE_MD_RE = /^\*\*([^*]+)\*\*\s*—\s*(.+)/m

const BOLD_SECTION_RE = /^\*\*([^*]+)\*\*\s*(?:—\s*)?/m

export function syncSkills(db: any): number {
  const entries = readdirSync(SKILLS_DIR, { withFileTypes: true })
  const skillDirs = entries.filter(e => e.isDirectory()).map(e => e.name).sort()

  const stmt = db.query(`
    INSERT INTO skills (id, title, description, trigger, procedure, gotchas, rules, body, skill, state_profile, related)
    VALUES ($id, $title, $description, $trigger, $procedure, $gotchas, $rules, $body, $skill, $state_profile, $related)
    ON CONFLICT(id) DO UPDATE SET
      title = $title, description = $description,
      trigger = $trigger, procedure = $procedure,
      gotchas = $gotchas, rules = $rules, body = $body,
      skill = $skill, state_profile = $state_profile,
      related = $related
  `)

  const KNOWN = new Set(["Trigger", "Procedure", "Gotchas", "Rules"])

  function extractSections(text: string): Record<string, string> {
    const sections: Record<string, string> = {}
    const parts = text.split(BOLD_SECTION_RE)
    for (let i = 1; i < parts.length; i += 2) {
      sections[parts[i].trim()] = (parts[i + 1]?.trim() ?? "")
    }
    return sections
  }

  let count = 0
  for (const dir of skillDirs) {
    const filePath = join(SKILLS_DIR, dir, "SKILL.md")
    try {
      const text = readFileSync(filePath, "utf-8")
      const r = extractFrontmatter(text)
      if (!r) continue
      const { body: bodyText, fm } = r
      const name = String(fm.name ?? "")
      const description = String(fm.description ?? "")
      const state_profile = String(fm["state-profile"] ?? "")
      const related = normalizeArray(fm.related)
      const terms = normalizeArray(fm.terms)
      const patterns = normalizeArray(fm.patterns)
      const id = `SKL.${name.toUpperCase().replace(/-/g, ".")}`
      const title = name.split("-").map((w: string) => w.charAt(0).toUpperCase() + w.slice(1)).join(" ")

      const sections = extractSections(bodyText)

      const extra: string[] = []
      for (const [header, content] of Object.entries(sections)) {
        if (!KNOWN.has(header)) {
          extra.push(`## ${header}\n${content}`)
        }
      }

      stmt.run({
        $id: id,
        $title: title,
        $description: description,
        $trigger: sections["Trigger"] ?? null,
        $procedure: sections["Procedure"] ?? null,
        $gotchas: sections["Gotchas"] ?? null,
        $rules: sections["Rules"] ?? null,
        $body: extra.length > 0 ? extra.join("\n\n") : null,
        $skill: name,
        $state_profile: state_profile,
        $related: related,
      })
      syncJunction(db, "skill", id, terms, patterns)
      count++
    } catch {
      // skip dirs without valid SKILL.md
    }
  }
  return count
}

function syncTable(
  db: any,
  dir: string,
  parser: (path: string) => any,
  table: string,
  columns: string[],
  conflictCols: string[],
  sourceType?: string,
) {
  const files = readdirSync(dir).filter(f => f.endsWith(".md")).sort()
  const colList = columns.join(", ")
  const paramList = columns.map(c => `$${c}`).join(", ")
  const sets = conflictCols.map(c => `${c} = $${c}`).join(", ")

  const stmt = db.query(`
    INSERT INTO ${table} (${colList})
    VALUES (${paramList})
    ON CONFLICT(id) DO UPDATE SET ${sets}
  `)

  let count = 0
  for (const file of files) {
    const data = parser(join(dir, file))
    const params: Record<string, any> = {}
    for (const col of columns) {
      params[`$${col}`] = data[col] ?? null
    }
    stmt.run(params)
    if (sourceType) {
      syncJunction(db, sourceType, data.id, data.terms, data.patterns)
    }
    count++
  }

  // cleanup stale DB rows (deleted files)
  if (files.length > 0) {
    const ids = files.map(f => f.replace(/\.md$/, ""))
    const ph = ids.map(() => "?").join(",")
    db.run(`DELETE FROM ${table} WHERE id NOT IN (${ph})`, ...ids)
  } else {
    db.run(`DELETE FROM ${table} WHERE 1=1`)
  }

  return count
}

export function syncJunction(db: any, sourceType: string, sourceId: string, terms: string | null, patterns: string | null) {
  db.query("DELETE FROM entity_terms WHERE source_type = $st AND source_id = $si").run({ $st: sourceType, $si: sourceId })
  db.query("DELETE FROM entity_patterns WHERE source_type = $st AND source_id = $si").run({ $st: sourceType, $si: sourceId })
  if (terms) {
    const s = db.query("INSERT OR IGNORE INTO entity_terms (source_type, source_id, term_id) VALUES ($st, $si, $tid)")
    for (const t of terms.split(",")) s.run({ $st: sourceType, $si: sourceId, $tid: t.trim() })
  }
  if (patterns) {
    const s = db.query("INSERT OR IGNORE INTO entity_patterns (source_type, source_id, pattern_id) VALUES ($st, $si, $pid)")
    for (const p of patterns.split(",")) s.run({ $st: sourceType, $si: sourceId, $pid: p.trim() })
  }
}

export function parseCommandFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const yaml = parseYaml(text) ?? {}
  return {
    id: String(yaml.id ?? ""),
    title: String(yaml.title ?? ""),
    description: yaml.description ? String(yaml.description) : null,
    source: yaml.source ? String(yaml.source) : null,
    tags: normalizeArray(yaml.tags),
    related: normalizeArray(yaml.related),
    terms: normalizeArray(yaml.terms),
    patterns: normalizeArray(yaml.patterns),
    created: yaml.created ? String(yaml.created) : new Date().toISOString(),
    modified: yaml.modified ? String(yaml.modified) : new Date().toISOString(),
  }
}

export function syncRules(db: any): number {
  const files = readdirSync(RULES_DIR).filter(f => f.endsWith(".yaml")).sort()
  const rulesDir = dirname(RULES_DIR)
  const stmt = db.query(`
    INSERT INTO rules (id, title, source, tags, related, body, created, modified)
    VALUES ($id, $title, $source, $tags, $related, $body, $created, $modified)
    ON CONFLICT(id) DO UPDATE SET title = $title, source = $source, tags = $tags, related = $related, body = $body, modified = $modified
  `)

  let count = 0
  for (const file of files) {
    const data = parseRuleFile(join(RULES_DIR, file))
    const mdFile = file.replace(/\.yaml$/, ".md")
    const mdPath = join(rulesDir, mdFile)
    const body = existsSync(mdPath) ? readFileSync(mdPath, "utf-8").trim() : null
    stmt.run({
      $id: data.id,
      $title: data.title,
      $source: data.source,
      $tags: data.tags,
      $related: data.related,
      $body: body,
      $created: data.created,
      $modified: data.modified,
    })
    syncJunction(db, "rule", data.id, data.terms, data.patterns)
    count++
  }
  return count
}

export function syncCommands(db: any): number {
  const files = readdirSync(COMMANDS_YAML_DIR).filter(f => f.endsWith(".yaml")).sort()
  const stmt = db.query(`
    INSERT INTO commands (id, title, description, source, tags, related, created, modified)
    VALUES ($id, $title, $description, $source, $tags, $related, $created, $modified)
    ON CONFLICT(id) DO UPDATE SET title = $title, description = $description, source = $source, tags = $tags, related = $related, modified = $modified
  `)

  let count = 0
  for (const file of files) {
    const data = parseCommandFile(join(COMMANDS_YAML_DIR, file))
    stmt.run({
      $id: data.id,
      $title: data.title,
      $description: data.description,
      $source: data.source,
      $tags: data.tags,
      $related: data.related,
      $created: data.created,
      $modified: data.modified,
    })
    syncJunction(db, "command", data.id, data.terms, data.patterns)
    count++
  }
  return count
}

export function parsePersonFile(filePath: string) {
  const text = readFileSync(filePath, "utf-8")
  const r = extractFrontmatter(text)
  if (!r) throw new Error(`Missing frontmatter: ${filePath}`)
  const { body, fm } = r
  return {
    id: String(fm.id ?? ""),
    title: String(fm.title ?? ""),
    body,
    subtype: fm.subtype ? String(fm.subtype) : null,
    source: fm.source ? String(fm.source) : null,
    tags: normalizeArray(fm.tags),
    created: fm.created ? String(fm.created) : new Date().toISOString(),
    modified: fm.modified ? String(fm.modified) : new Date().toISOString(),
  }
}

export function syncPersons(db: any): number {
  const files = readdirSync(PERSONS_DIR).filter(f => f.endsWith(".md")).sort()
  const stmt = db.query(`
    INSERT INTO persons (id, title, subtype, source, tags, body, created, modified)
    VALUES ($id, $title, $subtype, $source, $tags, $body, $created, $modified)
    ON CONFLICT(id) DO UPDATE SET
      title = $title, subtype = $subtype, source = $source,
      tags = $tags, body = $body, modified = $modified
  `)

  let count = 0
  for (const file of files) {
    const data = parsePersonFile(join(PERSONS_DIR, file))
    stmt.run({
      $id: data.id,
      $title: data.title,
      $subtype: data.subtype,
      $source: data.source,
      $tags: data.tags,
      $body: data.body,
      $created: data.created,
      $modified: data.modified,
    })
    count++
  }

  // Programmatic Staleness Check
  const activeIds = files.map(f => parsePersonFile(join(PERSONS_DIR, f)).id)
  const links = db.query("SELECT person_id, event_id FROM person_events").all()
  const allEvents = db.query("SELECT id FROM events").all().map(r => r.id)
  const report = detectPersonStaleness(activeIds, links, allEvents)

  if (report.staleLinks.length > 0 || report.orphanedEvents.length > 0) {
    console.warn(`\\n[Person Staleness] Found ${report.staleLinks.length} stale links and ${report.orphanedEvents.length} orphaned events.`)
    if (report.staleLinks.length > 0) console.warn(`  Stale Links: ${report.staleLinks.join(", ")}`)
    if (report.orphanedEvents.length > 0) console.warn(`  Orphaned Events: ${report.orphanedEvents.join(", ")}`)
  }

  return count
}

function syncIllustrationJunction(db: any, illustrationId: string, illustrates: string | null) {
  db.query("DELETE FROM illustration_entities WHERE illustration_id = $id").run({ $id: illustrationId })
  if (!illustrates) return
  const stmt = db.query("INSERT INTO illustration_entities (illustration_id, entity_id, entity_type) VALUES ($iid, $eid, $etype)")
  for (const eid of illustrates.split(",").map(s => s.trim()).filter(Boolean)) {
    const prefix = eid.split(".")[0]
    const etype = ID_PREFIX_TO_ENTITY_TYPE[prefix]
    if (etype) stmt.run({ $iid: illustrationId, $eid: eid, $etype: etype })
  }
}

export function syncIllustrations(db: any): number {
  const files = readdirSync(ILLUSTRATIONS_DIR).filter(f => f.endsWith(".md")).sort()
  const stmt = db.query(`
    INSERT INTO illustrations (id, title, body, source, summary, illustration, illustrates, related, tags, created, modified)
    VALUES ($id, $title, $body, $source, $summary, $illustration, $illustrates, $related, $tags, $created, $modified)
    ON CONFLICT(id) DO UPDATE SET
      title = $title, body = $body, source = $source, summary = $summary,
      illustration = $illustration, illustrates = $illustrates, related = $related,
      tags = $tags, modified = $modified
  `)
  let count = 0
  for (const file of files) {
    const data = parseIllustrationFile(join(ILLUSTRATIONS_DIR, file))
    stmt.run({
      $id: data.id, $title: data.title, $body: data.body,
      $source: data.source, $summary: data.summary,
      $illustration: data.illustration, $illustrates: data.illustrates,
      $related: data.related, $tags: data.tags,
      $created: data.created, $modified: data.modified,
    })
    syncIllustrationJunction(db, data.id, data.illustrates)
    count++
  }
  return count
}

export function syncAll(db: any, type?: string): string {
  const results: string[] = []
  const match = (t: string) => !type || type === "all" || type === t

  if (match("rules")) {
    const c = syncRules(db)
    results.push(pluralize(c, "rule"))
  }

  if (match("patterns")) {
    const cols = ["id", "title", "body", "source", "summary", "principle", "enforcement", "status", "priority", "tags", "created", "modified"]
    const conflict = ["title", "body", "source", "summary", "principle", "enforcement", "status", "priority", "tags", "modified"]
    const c = syncTable(db, PATTERNS_DIR, parsePatternFile, "patterns", cols, conflict, "pattern")
    results.push(pluralize(c, "pattern"))
  }

  if (match("maxims")) {
    const cols = ["id", "title", "body", "source", "summary", "principle", "enforcement", "status", "priority", "tags", "related", "created", "modified"]
    const conflict = ["title", "body", "source", "summary", "principle", "enforcement", "status", "priority", "tags", "related", "modified"]
    const c = syncTable(db, MAXIMS_DIR, parseMaximFile, "maxims", cols, conflict)
    results.push(pluralize(c, "maxim"))
  }

  if (match("terms")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, TERMS_DIR, parseTermFile, "terms", cols, conflict, "term")
    results.push(pluralize(c, "term"))
  }

  if (match("bio")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, BIO_DIR, parseBioFile, "bio", cols, conflict)
    results.push(pluralize(c, "bio"))
  }

  if (match("chem")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, CHEM_DIR, parseChemFile, "chem", cols, conflict)
    results.push(pluralize(c, "chem"))
  }

  if (match("taxonomy")) {
    const cols = ["id", "title", "body", "source", "rank", "precedes", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "rank", "precedes", "related", "tags", "reference", "modified"]
    const c = syncTable(db, TAXONOMY_DIR, parseTaxFile, "taxonomy", cols, conflict)
    results.push(pluralize(c, "taxon"))
  }

  if (match("ml")) {
    const cols = ["id", "title", "body", "source", "type", "paradigm", "subfield", "category", "precedes", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "type", "paradigm", "subfield", "category", "precedes", "related", "tags", "reference", "modified"]
    const c = syncTable(db, ML_DIR, parseMlFile, "ml", cols, conflict)
    results.push(pluralize(c, "ml entity"))
  }

  if (match("bash")) {
    const cols = ["id", "title", "body", "source", "precedes", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "precedes", "related", "tags", "reference", "modified"]
    const c = syncTable(db, BASH_DIR, parseBashFile, "bash", cols, conflict)
    results.push(pluralize(c, "bash entity"))
  }

  if (match("ruby")) {
    const cols = ["id", "title", "body", "source", "precedes", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "precedes", "related", "tags", "reference", "modified"]
    const c = syncTable(db, RUBY_DIR, parseRubyFile, "ruby", cols, conflict)
    results.push(pluralize(c, "ruby entity"))
  }

  if (match("cognitions")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, COGNITIONS_DIR, parseCognitionFile, "cognitions", cols, conflict)
    results.push(pluralize(c, "cognition"))
  }

  if (match("concepts")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, CONCEPTS_DIR, parseConceptFile, "concepts", cols, conflict)
    results.push(pluralize(c, "concept"))
  }

  if (match("definitions")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, DEFINITIONS_DIR, parseDefinitionFile, "definitions", cols, conflict)
    results.push(pluralize(c, "definition"))
  }

  if (match("identities")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, IDENTITIES_DIR, parseIdentityFile, "identities", cols, conflict)
    results.push(pluralize(c, "identity"))
  }

  if (match("specifications")) {
    const cols = ["id", "title", "body", "source", "summary", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "summary", "related", "tags", "reference", "modified"]
    const c = syncTable(db, SPECIFICATIONS_DIR, parseSpecificationFile, "specifications", cols, conflict)
    results.push(pluralize(c, "specification"))
  }

  if (match("precepts")) {
    const cols = ["id", "title", "body", "source", "summary", "precept", "enforcement", "status", "priority", "tags", "related", "created", "modified"]
    const conflict = ["title", "body", "source", "summary", "precept", "enforcement", "status", "priority", "tags", "related", "modified"]
    const c = syncTable(db, PRECEPTS_DIR, parsePreceptFile, "precepts", cols, conflict)
    results.push(pluralize(c, "precept"))
  }

  if (match("manifests")) {
    const cols = ["id", "title", "body", "source", "tags", "related", "created", "modified"]
    const conflict = ["title", "body", "source", "tags", "related", "modified"]
    const c = syncTable(db, MANIFESTS_DIR, parseManifestFile, "manifests", cols, conflict)
    results.push(pluralize(c, "manifest"))
  }

  if (match("skills")) {
    const c = syncSkills(db)
    results.push(pluralize(c, "skill"))
  }

  if (match("apologias")) {
    const cols = ["id", "title", "body", "source", "tags", "related", "created", "modified"]
    const conflict = ["title", "body", "source", "tags", "related", "modified"]
    const c = syncTable(db, APOLOGIAS_DIR, parseApologiaFile, "apologias", cols, conflict)
    results.push(pluralize(c, "apologia"))
  }

  if (match("commands")) {
    const c = syncCommands(db)
    results.push(pluralize(c, "command"))
  }

  if (match("nexus")) {
    const cols = ["id", "title", "body", "source", "summary", "nexus", "composition", "status", "priority", "tags", "related", "created", "modified"]
    const conflict = ["title", "body", "source", "summary", "nexus", "composition", "status", "priority", "tags", "related", "modified"]
    const c = syncTable(db, NEXUS_DIR, parseNexusFile, "nexus", cols, conflict)
    results.push(`${c} nex${c !== 1 ? "i" : "us"}`)
  }

  if (match("protocols")) {
    const cols = ["id", "title", "body", "source", "protocol", "enforcement", "status", "priority", "tags", "related", "created", "modified"]
    const conflict = ["title", "body", "source", "protocol", "enforcement", "status", "priority", "tags", "related", "modified"]
    const c = syncTable(db, PROTOCOLS_DIR, parseProtocolFile, "protocols", cols, conflict, "protocol")
    results.push(pluralize(c, "protocol"))
  }

  if (match("refs")) {
    const cols = ["id", "title", "body", "source", "ref_text", "tags", "related", "created", "modified"]
    const conflict = ["title", "body", "source", "ref_text", "tags", "related", "modified"]
    const c = syncTable(db, REFS_DIR, parseRefFile, "refs", cols, conflict, "ref")
    results.push(pluralize(c, "ref"))
  }

  if (match("illustrations")) {
    const c = syncIllustrations(db)
    results.push(pluralize(c, "illustration"))
  }

  if (match("abstractions")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, ABSTRACTIONS_DIR, parseAbstractionFile, "abstractions", cols, conflict)
    results.push(pluralize(c, "abstraction"))
  }

  if (match("linguistics")) {
    const cols = ["id", "title", "body", "source", "related", "tags", "reference", "created", "modified"]
    const conflict = ["title", "body", "source", "related", "tags", "reference", "modified"]
    const c = syncTable(db, LINGUISTICS_DIR, parseLinguisticsFile, "linguistics", cols, conflict)
    results.push(pluralize(c, "linguistics entry"))
  }

  if (match("persons")) {
    const c = syncPersons(db)
    results.push(pluralize(c, "person"))
  }

  return `Synced ${results.join(", ")}.`
}
