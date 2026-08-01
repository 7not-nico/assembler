// exports: parseAtomXml, extractArxivId, parseTotalResults
// purity: pure
// depends-on: ./arxiv-types

import type { ArxivEntry } from "./arxiv-types"

const ENTRY_RE = /<entry[\s>][\s\S]*?<\/entry>/gi
const TAG_RE = (tag: string) => new RegExp(`<${tag}(?:\\s[^>]*)?>([\\s\\S]*?)<\\/${tag}>`, "i")
const AUTHOR_RE = /<author[\s>][\s\S]*?<name>([\s\S]*?)<\/name>[\s\S]*?<\/author>/gi
const LINK_RE = /<link[^>]*href="([^"]*)"[^>]*\/?>/gi
const CAT_RE = /<arxiv:primary_category[^>]*term="([^"]*)"/i

function extractTag(text: string, tag: string): string {
  const m = text.match(TAG_RE(tag))
  return m ? m[1].trim() : ""
}

function extractLinks(text: string): { absUrl: string; pdfUrl?: string } {
  let absUrl = ""
  let pdfUrl: string | undefined
  let m: RegExpExecArray | null
  while ((m = LINK_RE.exec(text)) !== null) {
    const href = m[1]
    if (href.includes("/abs/")) absUrl = href
    else if (href.includes("/pdf/")) pdfUrl = href
  }
  return { absUrl, pdfUrl }
}

function extractAuthors(text: string): string[] {
  const authors: string[] = []
  let m: RegExpExecArray | null
  while ((m = AUTHOR_RE.exec(text)) !== null) {
    authors.push(m[1].trim())
  }
  return authors
}

function cleanText(text: string): string {
  return text.replace(/\s+/g, " ").trim()
}

export function extractArxivId(url: string): string {
  const m = url.match(/arxiv\.org\/(?:abs|pdf)\/([\w.-]+)/)
  return m ? m[1] : url
}

export function parseTotalResults(xml: string): number {
  const val = extractTag(xml, "opensearch:totalResults") || extractTag(xml, "totalResults") || "0"
  return parseInt(val, 10) || 0
}

export function parseAtomXml(xml: string): ArxivEntry[] {
  const entries: ArxivEntry[] = []
  const total = parseTotalResults(xml)

  let m: RegExpExecArray | null
  ENTRY_RE.lastIndex = 0
  while ((m = ENTRY_RE.exec(xml)) !== null) {
    const block = m[0]
    const id = extractTag(block, "id")
    const title = cleanText(extractTag(block, "title"))
    const summary = cleanText(extractTag(block, "summary"))
    const published = extractTag(block, "published") || extractTag(block, "updated")
    const authors = extractAuthors(block)
    const catM = block.match(CAT_RE)
    const category = catM ? catM[1] : ""
    const { absUrl, pdfUrl } = extractLinks(block)

    entries.push({
      id: extractArxivId(id),
      title,
      summary,
      published,
      authors,
      category,
      pdfUrl,
      absUrl: absUrl || id,
    })
  }

  return entries
}
