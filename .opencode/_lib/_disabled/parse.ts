// exports: FRONTMATTER_RE, BACKMATTER_RE, extractFrontmatter, extractBackmatter, parseYaml, normalizeArray, normalizeReferences, validateEntityFields, validateEntityFile, pluralize
// purity: pure
// depends-on: js-yaml

import { load as yaml_load } from "js-yaml"

export const FRONTMATTER_RE = /^---\s*\n([\s\S]*?)---\s*\n/
export const BACKMATTER_RE = /---\s*\n([\s\S]*?)---\s*$/

interface FieldSpec {
  required?: boolean
}

const ENTITY_FIELD_SPECS: Record<string, Record<string, FieldSpec>> = {
  pattern:  { id: { required: true }, title: { required: true }, source: { required: true }, summary: { required: true }, principle: { required: true }, enforcement: { required: true }, tags: { required: true }, status: { required: true }, priority: { required: true } },
  term:     { id: { required: true }, title: { required: true } },
  rule:     { id: { required: true }, title: { required: true }, source: { required: true } },
  command:  { id: { required: true }, title: { required: true }, description: { required: true }, source: { required: true }, tags: { required: true } },
  skill:    { name: { required: true }, description: { required: true } },
  apologia: { id: { required: true }, title: { required: true }, source: { required: true }, tags: { required: true }, related: { required: true } },
  protocol: { id: { required: true }, title: { required: true }, source: { required: true }, protocol: { required: true }, enforcement: { required: true }, status: { required: true }, priority: { required: true }, tags: { required: true }, related: { required: true } },
  abstraction: { id: { required: true }, title: { required: true } },
  person: { id: { required: true }, title: { required: true }, subtype: { required: true } },
  illustration: { id: { required: true }, title: { required: true }, summary: { required: true }, illustration: { required: true }, illustrates: { required: true }, tags: { required: true }, source: { required: true } },
    maxim: { id: { required: true }, title: { required: true }, source: { required: true }, summary: { required: true }, principle: { required: true }, enforcement: { required: true }, tags: { required: true }, status: { required: true }, priority: { required: true } },
   specification: { id: { required: true }, title: { required: true }, source: { required: true }, summary: { required: true }, tags: { required: true }, status: { required: true } },
   ml: { id: { required: true }, title: { required: true }, source: { required: true }, type: { required: true }, paradigm: { required: true }, subfield: { required: true }, category: { required: true }, tags: { required: true }, reference: { required: true } },
   bash: { id: { required: true }, title: { required: true }, source: { required: true }, tags: { required: true } },
   ruby: { id: { required: true }, title: { required: true }, source: { required: true }, tags: { required: true } },
   manifest: { id: { required: true }, title: { required: true }, source: { required: true }, tags: { required: true } },
   nexus: { id: { required: true }, title: { required: true }, source: { required: true }, summary: { required: true }, nexus: { required: true }, composition: { required: true }, status: { required: true }, tags: { required: true } },
}

export function extractFrontmatter(text: string): { body: string; fm: Record<string, unknown> } | null {
  const m = text.match(FRONTMATTER_RE)
  if (!m) return null
  try {
    return { body: text.slice(m[0].length).trim(), fm: yaml_load(m[1].trim()) as Record<string, unknown> }
  } catch {
    return null
  }
}

export function extractBackmatter(text: string): { body: string; bm: Record<string, unknown> } | null {
  const m = text.match(BACKMATTER_RE)
  if (!m) return null
  try {
    return { body: text.slice(0, m.index).trim(), bm: yaml_load(m[1].trim()) as Record<string, unknown> }
  } catch {
    return null
  }
}

export function parseYaml(text: string): Record<string, unknown> | null {
  try {
    return yaml_load(text) as Record<string, unknown>
  } catch {
    return null
  }
}

export function normalizeArray(v: unknown): string | null {
  if (!v) return null
  if (Array.isArray(v)) return v.map(String).join(",")
  return String(v)
}

export function normalizeReferences(v: unknown): string | null {
  if (!v) return null
  if (!Array.isArray(v)) return JSON.stringify([String(v)])
  const urls = v.map((entry: unknown) => {
    if (typeof entry === "object" && entry !== null && "url" in entry) {
      return String((entry as Record<string, unknown>).url)
    }
    return String(entry)
  })
  return JSON.stringify(urls)
}

export function validateEntityFields(yaml: Record<string, unknown>, type: string): string[] {
  const spec = ENTITY_FIELD_SPECS[type]
  if (!spec) return []
  const violations: string[] = []
  for (const [field, cfg] of Object.entries(spec)) {
    if (cfg.required && (yaml[field] === undefined || yaml[field] === null || yaml[field] === "")) {
      violations.push(`Missing ${field}`)
    }
  }
  return violations
}

export function validateEntityFile(text: string, type: string): { body: string | null; yaml: Record<string, unknown> | null; violations: string[]; frontmatter: boolean } {
  const hasFmMarker = FRONTMATTER_RE.test(text)
  if (hasFmMarker) {
    const r = extractFrontmatter(text)
    if (!r) return { body: null, yaml: null, violations: ["Unparseable frontmatter YAML"], frontmatter: true }
    return { body: r.body, yaml: r.fm, violations: validateEntityFields(r.fm, type), frontmatter: true }
  }
  const hasBmMarker = BACKMATTER_RE.test(text)
  if (hasBmMarker) {
    const r = extractBackmatter(text)
    if (!r) return { body: null, yaml: null, violations: ["Unparseable backmatter YAML"], frontmatter: false }
    return { body: r.body, yaml: r.bm, violations: validateEntityFields(r.bm, type), frontmatter: false }
  }
  return { body: null, yaml: null, violations: ["Missing frontmatter"], frontmatter: false }
}

export function pluralize(n: number, word: string): string {
  if (n === 1) return `${n} ${word}`
  if (word === "specification") return `${n} specifications`
  if (word === "identity" || word === "Identity") return `${n} ${word.replace(/ity$/, "ities")}`
  return `${n} ${word}s`
}
