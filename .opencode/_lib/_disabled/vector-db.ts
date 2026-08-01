// exports: initVectorDB, VECTOR_DB_PATH, VECTOR_SCHEMA_PATH
// purity: io (DB connection, file read)
// depends-on: bun:sqlite, fs, path, ../_lib/paths, ../_lib/ensure-vector-schema

import { Database } from "bun:sqlite"
import { readFileSync, existsSync } from "fs"
import { join } from "path"
import { PATLIB_ROOT } from "./paths"
import { ensureVectorSchema } from "./ensure-vector-schema"

export const VECTOR_DB_PATH = join(PATLIB_ROOT, ".opencode", "patlib-vector.db")
export const VECTOR_SCHEMA_PATH = join(PATLIB_ROOT, ".opencode", "_schemas", "patlib-vector.sql")

export function initVectorDB(): Database {
  const db = new Database(VECTOR_DB_PATH)
  db.exec("PRAGMA journal_mode = DELETE")
  db.exec("PRAGMA foreign_keys = ON")
  if (existsSync(VECTOR_SCHEMA_PATH)) {
    try {
      db.exec(readFileSync(VECTOR_SCHEMA_PATH, "utf-8"))
    } catch (e: any) {
      if (!e?.message?.includes("duplicate")) throw e
    }
  }
  ensureVectorSchema(db)
  return db
}
