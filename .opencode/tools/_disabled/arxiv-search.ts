// @toolclass TRNS
// purity: io
// depends-on: ../_lib/arxiv-parse, ../_lib/arxiv-format, ../_lib/arxiv-types
import { tool } from "@opencode-ai/plugin"
import { crashOnError } from "../_lib/errors"
import { parseAtomXml, parseTotalResults } from "../_lib/arxiv-parse"
import { formatEntries } from "../_lib/arxiv-format"

const ARXIV_API = "https://export.arxiv.org"

const FIELD_PREFIX_RE = /^(ti|au|abs|co|jr|cat|rn|all):/

function buildQuery(args: {
  query?: string
  maxResults: number
  category?: string
  idList?: string
  start: number
  sortBy?: string
  sortOrder?: string
}): string {
  let searchPart = ""

  if (args.idList) {
    searchPart = `id_list=${args.idList}`
  } else if (args.query) {
    const sq = args.category
      ? `cat:${args.category}+AND+all:(${args.query})`
      : FIELD_PREFIX_RE.test(args.query)
        ? args.query
        : `all:${args.query}`
    searchPart = `search_query=${sq}`
  }

  const rest = new URLSearchParams()
  rest.set("start", String(args.start))
  rest.set("max_results", String(args.maxResults))
  rest.set("sortBy", args.sortBy ?? "relevance")
  rest.set("sortOrder", args.sortOrder ?? "descending")

  const qs = searchPart ? `${searchPart}&${rest.toString()}` : rest.toString()
  return `/api/query?${qs}`
}

async function fetchArxiv(urlPath: string): Promise<string> {
  const res = await fetch(`${ARXIV_API}${urlPath}`, {
    headers: { "User-Agent": "opencode/1.0" },
  })
  if (!res.ok) {
    throw new Error(`arXiv API returned HTTP ${res.status}`)
  }
  return res.text()
}

async function downloadPdf(pdfUrl: string, outPath: string): Promise<string> {
  const res = await fetch(pdfUrl, {
    headers: { "User-Agent": "opencode/1.0" },
  })
  if (!res.ok) throw new Error(`HTTP ${res.status}`)
  await Bun.write(outPath, await res.blob())
  return outPath
}

export default tool({
  description: "Search arxiv.org for academic papers and optionally download PDFs",
  args: {
    query: tool.schema.string().describe("Search query (arxiv syntax, use +AND+ for boolean, e.g. 'fts5+AND+vector')"),
    maxResults: tool.schema.number().optional().default(10).describe("Max papers to return"),
    category: tool.schema.string().optional().describe("Filter by arxiv category (e.g. cs.IR, cs.DB, cs.LG)"),
    idList: tool.schema.string().optional().describe("Comma-separated arxiv IDs to fetch (e.g. '2507.01103,2305.19231')"),
    start: tool.schema.number().optional().default(0).describe("Pagination offset (0-based)"),
    sortBy: tool.schema.string().optional().describe("Sort field: relevance, submittedDate, lastUpdatedDate"),
    sortOrder: tool.schema.string().optional().describe("Sort order: ascending, descending"),
    download: tool.schema.boolean().optional().default(false).describe("Download PDFs to findings/ directory"),
    outDir: tool.schema.string().optional().default("arxiv-search").describe("Subdirectory under findings/ for PDFs"),
  },
  async execute(args) {
    crashOnError()
    const query = args.query
    const maxResults = args.maxResults ?? 10
    const category = args.category ?? undefined
    const idList = args.idList ?? undefined
    const start = args.start ?? 0
    const sortBy = args.sortBy ?? undefined
    const sortOrder = args.sortOrder ?? undefined
    const download = args.download ?? false
    const outDir = args.outDir ?? "arxiv-search"

    if (!query && !idList) {
      return "Provide a search query or idList."
    }

    const urlPath = buildQuery({ query, maxResults, category, idList, start, sortBy, sortOrder })
    const xml = await fetchArxiv(urlPath)
    const entries = parseAtomXml(xml)
    const totalResults = parseTotalResults(xml)

    if (entries.length === 0) {
      return "No results found."
    }

    let result = formatEntries(entries, maxResults, totalResults)

    if (download && entries.length > 0) {
      const baseDir = `findings/${outDir}`
      const proc = Bun.spawnSync(["mkdir", "-p", baseDir])
      if (proc.exitCode !== 0) result += `\nWarning: could not create ${baseDir}\n`

      const dlLines: string[] = []
      for (let i = 0; i < Math.min(entries.length, maxResults); i++) {
        const e = entries[i]
        const pdfUrl = e.pdfUrl || `https://arxiv.org/pdf/${e.id}`
        const slug = e.id.replace(/\./g, "-").replace(/v\d+$/, "") + ".pdf"
        const outPath = `${baseDir}/${slug}`
        try {
          await downloadPdf(pdfUrl, outPath)
          dlLines.push(`  ✓ ${slug}`)
        } catch {
          dlLines.push(`  ✗ ${slug} (download failed)`)
        }
      }

      result += "\n---\nDownloads:\n" + dlLines.join("\n")
    }

    return result
  },
})
