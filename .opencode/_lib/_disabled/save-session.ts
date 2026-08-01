// exports: SESSION_DDL, sessionToRow
// purity: pure
// depends-on: none

export const SESSION_DDL: string = `
CREATE TABLE IF NOT EXISTS sessions (
  id TEXT PRIMARY KEY,
  project_id TEXT,
  directory TEXT,
  title TEXT,
  parent_id TEXT,
  additions INTEGER DEFAULT 0,
  deletions INTEGER DEFAULT 0,
  files_changed INTEGER DEFAULT 0,
  created_at INTEGER,
  updated_at INTEGER,
  last_seen_at INTEGER,
  shared_url TEXT,
  status TEXT DEFAULT 'active'
)
`

export interface SessionRow {
  id: string
  project_id: string | null
  directory: string | null
  title: string | null
  parent_id: string | null
  additions: number
  deletions: number
  files_changed: number
  created_at: number | null
  updated_at: number | null
  last_seen_at: number
  shared_url: string | null
  status: string
}

export interface SessionEvent {
  id: string
  projectID?: string
  directory?: string
  title?: string
  parentID?: string
  summary?: { additions?: number; deletions?: number; files?: number }
  share?: { url?: string }
  time?: { created?: number; updated?: number }
}

export function sessionToRow(s: SessionEvent, now: number, status: string = "active"): SessionRow {
  return {
    id: s.id,
    project_id: s.projectID ?? null,
    directory: s.directory ?? null,
    title: s.title ?? null,
    parent_id: s.parentID ?? null,
    additions: s.summary?.additions ?? 0,
    deletions: s.summary?.deletions ?? 0,
    files_changed: s.summary?.files ?? 0,
    created_at: s.time?.created ?? null,
    updated_at: s.time?.updated ?? null,
    last_seen_at: now,
    shared_url: s.share?.url ?? null,
    status,
  }
}
