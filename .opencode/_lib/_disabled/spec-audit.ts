// exports: auditText
// purity: pure
// depends-on: none

import type { Rule, Violation, AuditResult, ForbiddenPatterns, RatioPatterns, ProximityPatterns, CountPatterns } from "./spec-types"

function findLine(text: string, index: number): number {
  return text.slice(0, index).split("\n").length
}

function checkForbidden(text: string, rule: Rule, pat: ForbiddenPatterns): Violation[] {
  const violations: Violation[] = []
  for (const p of pat.patterns) {
    const re = new RegExp(p, "gi")
    let m: RegExpExecArray | null
    while ((m = re.exec(text)) !== null) {
      violations.push({
        rule: rule.id, title: rule.title, severity: rule.severity,
        line: findLine(text, m.index),
        message: `Forbidden pattern: ${m[0].trim()}`,
        suggestion: rule.suggestion,
      })
    }
  }
  return violations
}

function checkRatio(text: string, rule: Rule, pat: RatioPatterns): Violation[] {
  const posRe = new RegExp(pat.positive.join("|"), "gi")
  const negRe = new RegExp(pat.negative.join("|"), "gi")
  const pos = (text.match(posRe) || []).length
  const neg = (text.match(negRe) || []).length
  const ratio = neg > 0 ? pos / neg : Infinity
  if (neg > 0 && ratio < (rule.threshold ?? 3)) {
    return [{
      rule: rule.id, title: rule.title, severity: rule.severity,
      line: 1,
      message: `Ratio ${ratio.toFixed(1)}:1 positive-to-negative (need ≥${rule.threshold ?? 3}:1). ${pos} positive, ${neg} negative.`,
      suggestion: rule.suggestion,
    }]
  }
  return []
}

function checkProximity(text: string, rule: Rule, pat: ProximityPatterns): Violation[] {
  const violations: Violation[] = []
  const trigRe = new RegExp(pat.trigger, "gi")
  const expRe = new RegExp(pat.expected, "gi")
  const maxDist = rule.threshold ?? 5
  const lines = text.split("\n")

  let m: RegExpExecArray | null
  while ((m = trigRe.exec(text)) !== null) {
    const line = findLine(text, m.index)
    const start = Math.max(0, line - 1)
    const end = Math.min(lines.length, line + maxDist)
    const scope = lines.slice(start, end).join("\n")
    if (!expRe.test(scope)) {
      violations.push({
        rule: rule.id, title: rule.title, severity: rule.severity,
        line,
        message: `Hard stop "${m[0].trim()}" missing positive redirect within ${maxDist} lines.`,
        suggestion: rule.suggestion,
      })
    }
  }
  return violations
}

function checkCount(text: string, rule: Rule, pat: CountPatterns): Violation[] {
  const segments = rule.scope === "segment" ? text.split(/\n\s*\n/) : [text]
  const violations: Violation[] = []
  const maxCount = rule.threshold ?? 6

  for (let i = 0; i < segments.length; i++) {
    const re = new RegExp(pat.patterns.join("|"), "gi")
    const count = (segments[i].match(re) || []).length
    if (count > maxCount) {
      violations.push({
        rule: rule.id, title: rule.title, severity: rule.severity,
        line: findLine(text, text.indexOf(segments[i].slice(0, 20))),
        message: `${count} constraint-related terms in ${rule.scope} (max ${maxCount}).`,
        suggestion: rule.suggestion,
      })
    }
  }
  return violations
}

export function auditText(text: string, rules: Rule[]): AuditResult {
  const violations: Violation[] = []

  for (const rule of rules) {
    const pat = rule.patterns
    let results: Violation[] = []
    if (pat.type === "forbidden_pattern") results = checkForbidden(text, rule, pat)
    else if (pat.type === "ratio") results = checkRatio(text, rule, pat)
    else if (pat.type === "proximity") results = checkProximity(text, rule, pat)
    else if (pat.type === "count") results = checkCount(text, rule, pat)
    violations.push(...results)
  }

  const score = violations.length === 0 ? 100 : Math.max(0, Math.round(100 - (violations.length / rules.length) * 100))
  return { score, total: rules.length, violations }
}
