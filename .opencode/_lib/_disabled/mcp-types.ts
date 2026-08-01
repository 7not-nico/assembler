// exports: EntityType, ValidStateProfile, IdPrefixMap, SearchParam, SearchRow, EntityDetail, IllustrationRelation, ValidationCount, ValidationReport
// purity: pure
// depends-on: none

export const EntityTypes = ["terms", "identities", "bio", "chem", "taxonomy", "ml", "bash", "ruby", "patterns", "cognitions", "concepts", "definitions", "skills", "rules", "apologias", "commands", "protocols", "refs", "abstractions", "nexus", "persons", "illustrations", "maxims", "precepts", "specifications"] as const
export type EntityType = typeof EntityTypes[number]
export const ENTITY_TYPES = EntityTypes

export const VALID_STATE_PROFILES = ["stateless", "stateful-reader", "stateful-writer", "stateful-auditor", "hybrid"] as const

export const IdPrefixMap: Record<string, string> = {
  PAT: "patterns", PROT: "protocols", REF: "refs",
  COG: "cognitions", CON: "concepts", DEF: "definitions", TERM: "terms", IDENTITY: "identities",
  BIO: "bio", CHEM: "chem", TAX: "taxonomy", ML: "ml", BASH: "bash", RUBY: "ruby",
  RUL: "rules", SKL: "skills", CMD: "commands", SPEC: "specifications",
  APO: "apologias", ABS: "abstractions", NEX: "nexus",
  PER: "persons", ILL: "illustrations", MAX: "maxims", PRE: "precepts",
}

export interface SearchParam {
  tag?: string
  source?: string
  query?: string
  status?: string
  state_profile?: string
  limit: number
  offset: number
}

export interface SearchRow {
  id: string
  title: string
  source: string | null
  tags: string | null
  summary?: string | null
  state_profile?: string | null
}

export interface EntityDetail {
  id: string
  title: string
  body: string
  source: string | null
  tags: string | null
  summary?: string | null
  principle?: string | null
  enforcement?: string | null
  status?: string | null
  priority?: number | null
  related?: string | null
  protocol?: string | null
  description?: string | null
  state_profile?: string | null
}

export interface IllustrationRelation {
  illustration_id: string
  illustration_title: string
  entity_id: string
  entity_title: string
  entity_type: string
}

export interface ValidationCount {
  patterns: number
  terms: number
  cognitions: number
  concepts: number
  definitions: number
  skills: number
  apologias: number
  protocols: number
  persons: number
  illustrations: number
  maxims: number
  specifications: number
  nexus: number
}

export interface ValidationReport {
  counts: ValidationCount
  violations: string[]
}
