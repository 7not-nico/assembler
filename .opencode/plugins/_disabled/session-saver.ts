// @pluginclass TRNS
import { initSessionDB } from "../_lib/db"
import { sessionToRow } from "../_lib/save-session"
import type { Database } from "bun:sqlite"

const WATCHED_EVENTS = new Set(["session.created", "session.updated", "session.deleted", "session.compacted"])

export const SessionSaver = async ({ client }: { client: any }) => {
  let db: Database

  try {
    db = initSessionDB()
  } catch (err) {
    await client.app.log({
      body: { level: "error", service: "session-saver", message: `init-fail: ${(err as Error).message}` },
    })
    return {}
  }

  const upsert = db.query(`
    INSERT OR REPLACE INTO sessions (id, project_id, directory, title, parent_id, additions, deletions, files_changed, created_at, updated_at, last_seen_at, shared_url, status)
    VALUES ($id, $project_id, $directory, $title, $parent_id, $additions, $deletions, $files_changed, $created_at, $updated_at, $last_seen_at, $shared_url, $status)
  `)

  const setStatus = db.query(`
    UPDATE sessions SET status = $status, last_seen_at = $now WHERE id = $id
  `)

  return {
    event: async ({ event }: { event: any }) => {
      if (!WATCHED_EVENTS.has(event.type)) return

      try {
        if (event.type === "session.compacted") {
          setStatus.run({ $status: "compacted", $now: Date.now(), $id: event.properties.sessionID })
          return
        }

        const info = event.properties.info
        if (!info?.id) return

        const status = event.type === "session.deleted" ? "deleted" : "active"
        const row = sessionToRow(info, Date.now(), status)
        upsert.run({
          $id: row.id,
          $project_id: row.project_id,
          $directory: row.directory,
          $title: row.title,
          $parent_id: row.parent_id,
          $additions: row.additions,
          $deletions: row.deletions,
          $files_changed: row.files_changed,
          $created_at: row.created_at,
          $updated_at: row.updated_at,
          $last_seen_at: row.last_seen_at,
          $shared_url: row.shared_url,
          $status: row.status,
        })
      } catch (err) {
        await client.app.log({
          body: { level: "error", service: "session-saver", message: `event-error: ${(err as Error).message}` },
        })
      }
    },
  }
}
