// exports: auditProtocolBody, auditPatternBody, auditEntityFile
// purity: pure
// depends-on: none

export interface Violation {
  rule: string
  line: number
  message: string
}

export interface AuditResult {
  path: string
  type: "protocol" | "pattern" | "maxim"
  score: number
  violations: Violation[]
}

const SPECIFIC_PLUGINS = [
  "auto-sync", "log-mcp", "audit-events", "ref-integrity",
  "bash-guard", "cmd-audit", "session-saver",
]

const PLUGIN_FILE_RE = /\.opencode\/plugins\/\w+\.ts/g
const PLUGIN_NAME_RE = new RegExp(`\\b(${SPECIFIC_PLUGINS.join("|")})\\b`, "g")

function findLine(text: string, index: number): number {
  return text.slice(0, index).split("\n").length
}

function splitBody(text: string): { frontmatter: string; body: string; gotchas: string; seeAlso: string } {
  const lines = text.split("\n")
  let frontmatterEnd = 0
  let gotchasStart = lines.length
  let seeAlsoStart = lines.length

  if (lines[0]?.trim() === "---") {
    for (let i = 1; i < lines.length; i++) {
      if (lines[i]?.trim() === "---") { frontmatterEnd = i + 1; break }
    }
  }

  for (let i = 0; i < lines.length; i++) {
    if (/^##\s+Gotchas/i.test(lines[i])) { gotchasStart = i; break }
  }

  for (let i = 0; i < lines.length; i++) {
    if (/^##\s+See also/i.test(lines[i])) { seeAlsoStart = i; break }
  }

  const bodyEnd = Math.min(gotchasStart, seeAlsoStart)

  return {
    frontmatter: lines.slice(0, frontmatterEnd).join("\n"),
    body: lines.slice(frontmatterEnd, bodyEnd).join("\n"),
    gotchas: lines.slice(gotchasStart, seeAlsoStart).join("\n"),
    seeAlso: lines.slice(seeAlsoStart).join("\n"),
  }
}

function checkConcreteNames(body: string, re: RegExp, rule: string, violations: Violation[]): void {
  re.lastIndex = 0
  let m: RegExpExecArray | null
  for (m = re.exec(body); m; m = re.exec(body)) {
    violations.push({ rule, line: findLine(body, m.index), message: `Contains concrete name: ${m[0]}` })
  }
}

export function auditProtocolBody(text: string): Violation[] {
  const { body } = splitBody(text)
  const violations: Violation[] = []
  checkConcreteNames(body, PLUGIN_NAME_RE, "concrete-name-plugin", violations)
  checkConcreteNames(body, PLUGIN_FILE_RE, "concrete-name-path", violations)
  return violations
}

export function auditPatternBody(text: string): Violation[] {
  const { body } = splitBody(text)
  const violations: Violation[] = []
  checkConcreteNames(body, PLUGIN_NAME_RE, "concrete-name-plugin", violations)
  checkConcreteNames(body, PLUGIN_FILE_RE, "concrete-name-path", violations)
  return violations
}

export function auditEntityFile(filePath: string, text: string): AuditResult {
  const isProtocol = filePath.includes("/protocols/") || filePath.startsWith("PROT.")
  const isMaxim = filePath.includes("/maxims/") || filePath.startsWith("MAX.")
  let type: "protocol" | "pattern" | "maxim" = isProtocol ? "protocol" : isMaxim ? "maxim" : "pattern"
  const violations = (isProtocol || isMaxim) ? auditProtocolBody(text) : auditPatternBody(text)
  const score = violations.length === 0 ? 100 : Math.max(0, 100 - violations.length * 20)
  return { path: filePath, type, score, violations }
}