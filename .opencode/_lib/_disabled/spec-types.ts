// exports: CheckType, RuleRow, Rule, ForbiddenPattern, RatioPattern, ProximityPattern, CountPattern, Violation, AuditReport
// purity: pure
// depends-on: none

export type CheckType = "forbidden_pattern" | "ratio" | "proximity" | "count"

export interface RuleRow {
  id: string
  title: string
  description: string | null
  severity: "error" | "warn"
  check_type: CheckType
  patterns: string
  threshold: number | null
  scope: string
  suggestion: string | null
  enabled: number
}

export interface Rule {
  id: string
  title: string
  description: string | null
  severity: "error" | "warn"
  checkType: CheckType
  patterns: ForbiddenPattern | RatioPattern | ProximityPattern | CountPattern
  threshold: number | null
  scope: string
  suggestion: string | null
}

export interface ForbiddenPattern {
  type: "forbidden_pattern"
  patterns: string[]
}

export interface RatioPattern {
  type: "ratio"
  positive: string[]
  negative: string[]
}

export interface ProximityPattern {
  type: "proximity"
  trigger: string
  expected: string
}

export interface CountPattern {
  type: "count"
  patterns: string[]
}

export interface Violation {
  rule: string
  title: string
  severity: "error" | "warn"
  line: number
  message: string
  suggestion: string | null
}

export interface AuditReport {
  score: number
  total: number
  violations: Violation[]
}
