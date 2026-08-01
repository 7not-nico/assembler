// exports: queryEmbeddingVectors, queryEntityEmbedding, queryFtsRank
// purity: io (DB queries)
// depends-on: bun:sqlite

import { Database } from "bun:sqlite"

export function queryEmbeddingVectors(
  vdb: Database,
  type?: string,
  field: string = "full",
): Array<{ entity_type: string; entity_id: string; vector: Float32Array }> {
  const rows = type
    ? vdb.query("SELECT entity_type, entity_id, vector FROM embeddings WHERE entity_type = ? AND field = ?").all(type, field)
    : vdb.query("SELECT entity_type, entity_id, vector FROM embeddings WHERE field = ?").all(field)
  return (rows as Array<Record<string, unknown>>).map(r => ({
    entity_type: String(r.entity_type),
    entity_id: String(r.entity_id),
    vector: new Float32Array(r.vector as ArrayBuffer),
  }))
}

export function queryEntityEmbedding(
  vdb: Database,
  entityId: string,
  type?: string,
  field: string = "full",
): Array<{ entity_type: string; entity_id: string; vector: Float32Array }> {
  const rows = type
    ? vdb.query("SELECT entity_type, entity_id, vector FROM embeddings WHERE entity_id = ? AND entity_type = ? AND field = ?").all(entityId, type, field)
    : vdb.query("SELECT entity_type, entity_id, vector FROM embeddings WHERE entity_id = ? AND field = ?").all(entityId, field)
  return (rows as Array<Record<string, unknown>>).map(r => ({
    entity_type: String(r.entity_type),
    entity_id: String(r.entity_id),
    vector: new Float32Array(r.vector as ArrayBuffer),
  }))
}

export function queryFtsRank(
  vdb: Database,
  ftsQuery: string,
  limit: number,
  type?: string,
  field: string = "full",
): Array<{ entity_type: string; entity_id: string; rank: number }> {
  const rows = type
    ? vdb.query(
        `SELECT e.entity_type, e.entity_id, fts.rank
         FROM entities_fts fts JOIN fts_entities e ON fts.rowid = e.id
         WHERE fts.content MATCH ? AND e.entity_type = ? AND e.field = ?
         ORDER BY fts.rank LIMIT ?`
      ).all(ftsQuery, type, field, limit)
    : vdb.query(
        `SELECT e.entity_type, e.entity_id, fts.rank
         FROM entities_fts fts JOIN fts_entities e ON fts.rowid = e.id
         WHERE fts.content MATCH ? AND e.field = ?
         ORDER BY fts.rank LIMIT ?`
      ).all(ftsQuery, field, limit)
  return (rows as Array<Record<string, unknown>>).map(r => ({
    entity_type: String(r.entity_type),
    entity_id: String(r.entity_id),
    rank: Number(r.rank),
  }))
}
