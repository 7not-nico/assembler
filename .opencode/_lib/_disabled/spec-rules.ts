// exports: loadRules
// purity: pure
// depends-on: spec-types

import type { Rule, CheckType, ForbiddenPatterns, RatioPatterns, ProximityPatterns, CountPatterns } from "./spec-types"

const RULES: Rule[] = [
  {
    id: "POSITIVE_FRAMING", title: "Positive framing required",
    description: null, severity: "error", checkType: "proximity" as CheckType,
    patterns: {
      type: "proximity",
      trigger: "\\b(don't|never|must not|should not|avoid|forbidden|prohibited)\\b",
      expected: "\\b(instead|alternatively|rather|redirect|prefer|use)\\b",
    } as ProximityPatterns,
    threshold: 5, scope: "document",
    suggestion: "Replace negative with positive instruction. Add \"instead\" redirect.",
  },
  {
    id: "RATIO_3_1", title: "3:1 positive-to-negative ratio",
    description: null, severity: "error", checkType: "ratio" as CheckType,
    patterns: {
      type: "ratio",
      positive: ["\\b(do|use|prefer|apply|follow|always|required|must|should)\\b"],
      negative: ["\\b(don't|never|must not|should not|avoid|forbidden)\\b"],
    } as RatioPatterns,
    threshold: 3, scope: "document",
    suggestion: "Add more positive instructions to reach ≥3:1 ratio.",
  },
  {
    id: "DECLARATIVE_REGISTER", title: "Declarative register over imperative",
    description: null, severity: "warn", checkType: "forbidden_pattern" as CheckType,
    patterns: {
      type: "forbidden_pattern",
      patterns: ["\\b(NEVER|DO NOT|ALWAYS AVOID|MUST NOT|CANNOT)\\b"],
    } as ForbiddenPatterns,
    threshold: null, scope: "line",
    suggestion: "Use \"X: disabled\" or declarative phrasing instead.",
  },
  {
    id: "FORBIDDEN_PRIMING", title: "No forbidden-concept priming",
    description: null, severity: "error", checkType: "forbidden_pattern" as CheckType,
    patterns: {
      type: "forbidden_pattern",
      patterns: ["do not use \\w+", "never use \\w+", "avoid using \\w+"],
    } as ForbiddenPatterns,
    threshold: null, scope: "line",
    suggestion: "Describe the boundary, not the prohibited entity. Use \"X: excluded\".",
  },
  {
    id: "CONSTRAINT_BUDGET", title: "Constraint budget ≤6 per segment",
    description: null, severity: "error", checkType: "count" as CheckType,
    patterns: {
      type: "count",
      patterns: ["\\b(constraint|rule|must|required|forbidden|disabled|allowed|permitted|banned|restricted)\\b"],
    } as CountPatterns,
    threshold: 6, scope: "segment",
    suggestion: "Reduce to ≤6 constraints per segment.",
  },
  {
    id: "STRUCTURAL_PREFERENCE", title: "Prefer structural over semantic constraints",
    description: null, severity: "warn", checkType: "ratio" as CheckType,
    patterns: {
      type: "ratio",
      positive: ["\\b(length|format|keyword|character|line|word|json|markdown|list|numbered|bullet)\\b"],
      negative: ["\\b(tone|style|concise|detailed|formal|friendly|professional|casual|voice|register)\\b"],
    } as RatioPatterns,
    threshold: 1, scope: "document",
    suggestion: "Replace semantic constraints with structural ones (length, format).",
  },
  {
    id: "HARD_STOP_REDIRECT", title: "Hard stop requires positive redirect",
    description: null, severity: "error", checkType: "proximity" as CheckType,
    patterns: {
      type: "proximity",
      trigger: "\\b(forbidden|prohibited|disabled|not allowed|banned|restricted)\\b",
      expected: "\\b(instead|alternatively|rather|instead of|prefer|replace|substitute)\\b",
    } as ProximityPatterns,
    threshold: 5, scope: "document",
    suggestion: "Add positive redirect after each hard stop.",
  },
  {
    id: "CONJUNCTION_OPERATOR", title: "No conjunction composition operators",
    description: null, severity: "warn", checkType: "forbidden_pattern" as CheckType,
    patterns: {
      type: "forbidden_pattern",
      patterns: ["&&", "∩"],
    } as ForbiddenPatterns,
    threshold: null, scope: "line",
    suggestion: "Use declarative listing instead of conjunction operators.",
  },
  {
    id: "NEGATION_OPERATOR", title: "No negation operators",
    description: null, severity: "warn", checkType: "forbidden_pattern" as CheckType,
    patterns: {
      type: "forbidden_pattern",
      patterns: ["(?<![a-z])NOT(?![a-z])", "!", "¬"],
    } as ForbiddenPatterns,
    threshold: null, scope: "line",
    suggestion: "Use \"X: disabled\" or \"X: excluded\" declarative form.",
  },
  {
    id: "XOR_OPERATOR", title: "XOR is structurally unreliable",
    description: null, severity: "warn", checkType: "forbidden_pattern" as CheckType,
    patterns: {
      type: "forbidden_pattern",
      patterns: ["\\bXOR\\b"],
    } as ForbiddenPatterns,
    threshold: null, scope: "line",
    suggestion: "Replace XOR with explicit IF/ELSE or declarative listing.",
  },
  {
    id: "IMPLICATION_OPERATOR", title: "Implication is model-specific",
    description: null, severity: "warn", checkType: "forbidden_pattern" as CheckType,
    patterns: {
      type: "forbidden_pattern",
      patterns: ["=>"],
    } as ForbiddenPatterns,
    threshold: null, scope: "line",
    suggestion: "Only use if empirically validated on target model. Default to declarative.",
  },
  {
    id: "CONNECTIVE_FRAGILITY", title: "High-entropy connectives flagged",
    description: null, severity: "warn", checkType: "forbidden_pattern" as CheckType,
    patterns: {
      type: "forbidden_pattern",
      patterns: ["\\b(therefore|however|but)\\b"],
    } as ForbiddenPatterns,
    threshold: null, scope: "line",
    suggestion: "Connectives derail 41% of reasoning chains. Use separate sentences.",
  },
]

export function loadRules(): Rule[] {
  return RULES
}
