// exports: ArxivEntry, ArxivQuery, ArxivSortBy, ArxivSortOrder, ArxivResponse
// purity: pure
// depends-on: none

export interface ArxivEntry {
  id: string
  title: string
  summary: string
  published: string
  authors: string[]
  category: string
  pdfUrl?: string
  absUrl: string
}

export interface ArxivQuery {
  query: string
  maxResults: number
  category?: string
  idList?: string
  start?: number
  sortBy?: ArxivSortBy
  sortOrder?: ArxivSortOrder
}

export type ArxivSortBy = "relevance" | "submittedDate" | "lastUpdatedDate"
export type ArxivSortOrder = "ascending" | "descending"

export interface ArxivResponse {
  entries: ArxivEntry[]
  totalResults: number
}
