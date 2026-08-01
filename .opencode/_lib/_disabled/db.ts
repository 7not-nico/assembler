// exports: initDB, initMCPDB, initSessionDB, queryAll, queryOne
// purity: io
// depends-on: paths, bun:sqlite, fs

import { Database } from "bun:sqlite"
import { readFileSync, readdirSync } from "fs"
import { join } from "path"
import { DB_PATH, SCHEMAS_DIR, SEEDS_DIR, MCP_DB_PATH, MCP_SCHEMA_PATH, LLM_SPEC_SCHEMA_PATH, SESSIONS_DB_PATH } from "./paths"

export function initDB(): Database {
  const db = new Database(DB_PATH)
  db.exec("PRAGMA journal_mode = WAL")
  db.exec("PRAGMA busy_timeout = 5000")
  // individual schema files per entity type — sorted, idempotent
  const schemaFiles = readdirSync(SCHEMAS_DIR).filter(f => f.endsWith(".sql")).sort()
  for (const f of schemaFiles) {
    try {
      db.exec(readFileSync(join(SCHEMAS_DIR, f), "utf-8"))
    } catch (e: any) {
      if (!e?.message?.includes("duplicate column name")) throw e
    }
  }
  try {
    db.exec(readFileSync(LLM_SPEC_SCHEMA_PATH, "utf-8"))
  } catch (e: any) {
    if (!e?.message?.includes("duplicate column name")) throw e
  }
  const seedFiles = readdirSync(SEEDS_DIR).filter(f => f.endsWith(".sql")).sort()
  for (const f of seedFiles) {
    try {
      db.exec(readFileSync(join(SEEDS_DIR, f), "utf-8"))
    } catch (e: any) {
      if (!e?.message?.includes("duplicate column name")) throw e
    }
  }
  return db
}

import { SESSION_DDL } from "./save-session"

export function initSessionDB(): Database {
  const db = new Database(SESSIONS_DB_PATH)
  db.exec(SESSION_DDL)
  return db
}

export function initMCPDB(): Database {
  const db = new Database(MCP_DB_PATH)
  db.exec("PRAGMA journal_mode = WAL")
  db.exec("PRAGMA busy_timeout = 5000")
  const schema = readFileSync(MCP_SCHEMA_PATH, "utf-8")
  db.exec(schema)
  return db
}

export function queryAll(db: Database, sql: string, params?: Record<string, unknown>): Record<string, unknown>[] {
  return db.query(sql).all(params) as Record<string, unknown>[]
}

export function queryOne(db: Database, sql: string, params?: Record<string, unknown>): Record<string, unknown> | null {
  return db.query(sql).get(params) as Record<string, unknown> | null ?? null
}
