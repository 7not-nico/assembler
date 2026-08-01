// exports: readEntityTexts
// purity: io (DB query)
// depends-on: bun:sqlite, entity-text, vector-query

import { Database } from "bun:sqlite"
import { buildEmbedText, buildEmbedTextMeta, buildEmbedTextBody, buildFtsText, buildFtsTextMeta, buildFtsTextBody, readEntityFields, readEntityExtraCols } from "./entity-text"
import { entityTable } from "./vector-query"

export interface EntityTexts {
  id: string
  type: string
  embedTextFull: string
  embedTextMeta: string
  embedTextBody: string
  ftsTextFull: string
  ftsTextMeta: string
  ftsTextBody: string
}

export async function readEntityTexts(
  patlib: Database,
  type: string,
): Promise<EntityTexts[]> {
  const table = entityTable(type)
  if (!table) return []

  const fields = readEntityFields(type)
  const extra = readEntityExtraCols(type)
  const sql = `SELECT ${fields.join(", ")}${extra.length ? ", " + extra.join(", ") : ""} FROM "${table}"`

  const rows = patlib.query(sql).all() as Array<Record<string, unknown>>
  return rows.map(r => ({
    id: String(r.id),
    type,
    embedTextFull: buildEmbedText(r, type),
    embedTextMeta: buildEmbedTextMeta(r, type),
    embedTextBody: buildEmbedTextBody(r, type),
    ftsTextFull: buildFtsText(r),
    ftsTextMeta: buildFtsTextMeta(r),
    ftsTextBody: buildFtsTextBody(r),
  }))
}
