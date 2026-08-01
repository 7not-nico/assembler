// exports: buildEmbedText, readEntityFields, ENTITY_BODY_TABLES, readEntityExtraCols, buildFtsText
// purity: pure
// depends-on: none

export function buildEmbedTextMeta(row: Record<string, unknown>, type: string): string {
  const parts: string[] = []
  const add = (k: string, weight = 1) => {
    if (row[k]) { for (let i = 0; i < weight; i++) parts.push(String(row[k])) }
  }
  add("title", 4)
  if (type === "patterns" || type === "maxims") { add("summary", 3); add("principle", 2) }
  if (type === "skills") add("description", 2)
  if (type === "commands") add("description", 2)
  if (type === "illustrations") add("summary", 3)
  return parts.join("\n")
}

export function buildEmbedTextBody(row: Record<string, unknown>, type?: string): string {
  const parts: string[] = []
  if (row.body) parts.push(String(row.body))
  if (type === "protocols" && row.protocol) parts.push(String(row.protocol))
  return parts.join("\n")
}

export function buildEmbedText(row: Record<string, unknown>, type: string): string {
  return buildEmbedTextMeta(row, type) + "\n" + buildEmbedTextBody(row)
}

export function buildFtsTextMeta(row: Record<string, unknown>): string {
  return [String(row.title ?? ""), String(row.protocol ?? ""),
          String(row.description ?? ""), String(row.summary ?? ""), String(row.principle ?? "")]
    .filter(s => s.length > 0)
    .join("\n")
}

export function buildFtsTextBody(row: Record<string, unknown>): string {
  return String(row.body ?? "")
}

export function buildFtsText(row: Record<string, unknown>): string {
  return buildFtsTextMeta(row) + "\n" + buildFtsTextBody(row)
}

export function readEntityFields(type: string): string[] {
  const fields = ["id", "title"]
  if (type === "patterns") { fields.push("summary", "principle") }
  if (type === "skills") { fields.push("description") }
  return fields
}

export const ENTITY_BODY_TABLES = new Set([
  "patterns", "terms", "cognitions", "concepts", "definitions",
  "skills", "rules", "protocols",
  "abstractions", "linguistics", "apologias", "persons",
  "illustrations", "maxims", "ml", "bash", "ruby",
])

export function readEntityExtraCols(type: string): string[] {
  const cols: string[] = []
  if (ENTITY_BODY_TABLES.has(type)) cols.push("COALESCE(body, '') as body")
  if (type === "protocols") cols.push("COALESCE(protocol, '') as protocol")
  if (type === "patterns" || type === "maxims") { cols.push("COALESCE(summary, '') as summary"); cols.push("COALESCE(principle, '') as principle") }
  if (type === "skills" || type === "commands") cols.push("COALESCE(description, '') as description")
  if (type === "illustrations") cols.push("COALESCE(summary, '') as summary")
  return cols
}
