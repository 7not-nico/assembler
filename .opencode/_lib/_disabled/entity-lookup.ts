// exports: getEntityTitle
// purity: io (DB query)
// depends-on: vector-query, bun:sqlite

import { Database } from "bun:sqlite"
import { entityTable } from "./vector-query"

export function getEntityTitle(patlib: Database, entityType: string, entityId: string): string {
  const table = entityTable(entityType)
  if (!table) return entityId
  const row = patlib.query(`SELECT title FROM "${table}" WHERE id = ?`).get(entityId) as Record<string, unknown> | null
  return (row?.title as string) ?? entityId
}
