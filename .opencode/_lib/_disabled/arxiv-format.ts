// exports: formatEntries
// purity: pure
// depends-on: ./arxiv-types

import type { ArxivEntry } from "./arxiv-types"

function truncate(text: string, max: number): string {
  if (text.length <= max) return text
  return text.slice(0, max - 1) + "…"
}

export function formatEntries(entries: ArxivEntry[], maxResults: number, totalResults?: number): string {
  if (entries.length === 0) return "No results found."

  const total = totalResults ?? entries.length
  const lines: string[] = [
    `Found ${total} paper(s) (showing top ${Math.min(entries.length, maxResults)})`,
    "",
  ]

  for (let i = 0; i < Math.min(entries.length, maxResults); i++) {
    const e = entries[i]
    const pubDate = e.published ? e.published.slice(0, 10) : "unknown"
    const authors = e.authors.length > 3
      ? e.authors.slice(0, 3).join(", ") + " et al."
      : e.authors.join(", ")

    lines.push(`${i + 1}. ${e.title}`)
    lines.push(`   ID: ${e.id}  |  ${pubDate}  |  ${e.category}`)
    lines.push(`   Authors: ${authors}`)
    if (e.summary) lines.push(`   ${truncate(e.summary, 200)}`)
    lines.push(`   ${e.absUrl}`)
    if (e.pdfUrl) lines.push(`   PDF: ${e.pdfUrl}`)
    lines.push("")
  }

  return lines.join("\n")
}
