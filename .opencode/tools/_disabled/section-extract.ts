// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { readFileSync } from "fs"
import { join } from "path"
import { crashOnError } from "../_lib/errors"
import { PATLIB_ROOT } from "../_lib/paths"

const H2_RE = /^## (.+)$/gm
const BOLD_RE = /^\*\*([^*]+)\*\*\s*(?:—\s*)?/m

const MAX_DETECT_LINES = 20

function detectStyle(text: string): "h2" | "bold" | "text" {
  const head = text.split("\n").slice(0, MAX_DETECT_LINES).join("\n")
  H2_RE.lastIndex = 0
  if (H2_RE.test(head)) return "h2"
  BOLD_RE.lastIndex = 0
  if (BOLD_RE.test(head)) return "bold"
  return "text"
}

function extractH2(text: string, filter?: Set<string>): Record<string, string> {
  const lines = text.split("\n")
  const sections: Record<string, string> = {}
  let currentHeader: string | null = null
  let currentContent: string[] = []

  for (const line of lines) {
    const m = line.match(/^## (.+)$/)
    if (m) {
      if (currentHeader && (!filter || filter.has(currentHeader))) {
        sections[currentHeader] = currentContent.join("\n").trim()
      }
      currentHeader = m[1].trim()
      currentContent = []
    } else if (currentHeader) {
      currentContent.push(line)
    }
  }
  if (currentHeader && (!filter || filter.has(currentHeader))) {
    sections[currentHeader] = currentContent.join("\n").trim()
  }
  return sections
}

function extractBold(text: string, filter?: Set<string>): Record<string, string> {
  const sections: Record<string, string> = {}
  const parts = text.split(BOLD_RE)
  for (let i = 1; i < parts.length; i += 2) {
    const header = parts[i].trim()
    const content = parts[i + 1]?.trim() ?? ""
    if (!filter || filter.has(header)) {
      sections[header] = content
    }
  }
  return sections
}

export default tool({
  description: "Extract sectioned content from an .md file by header style (## or **bold**)",
  args: {
    path: tool.schema.string().describe("File path relative to project root (e.g. .opencode/skills/audit-tools/SKILL.md)"),
    sections: tool.schema.string().optional().describe("Comma-separated section filter: return only these sections"),
  },
  async execute(args) {
    crashOnError()
    const filePath = join(PATLIB_ROOT, args.path)
    let text: string
    try {
      text = readFileSync(filePath, "utf-8")
    } catch {
      throw new Error(`File not found: ${args.path}`)
    }
    const style = detectStyle(text)
    const filter = args.sections ? new Set(args.sections.split(",").map(s => s.trim())) : undefined
    const sections = style === "h2" ? extractH2(text, filter) : extractBold(text, filter)

    const lines = [`style: ${style}`]
    for (const [header, content] of Object.entries(sections)) {
      lines.push(`\n## ${header}\n${content}`)
    }
    return lines.join("\n")
  },
})
