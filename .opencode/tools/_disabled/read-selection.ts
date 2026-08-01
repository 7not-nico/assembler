// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initDB, queryAll } from "../_lib/db"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "List and filter terms, patterns, skills, rules, apologias, commands, protocols, abstractions, linguistics entries, persons, illustrations, maxims, or tool classes from patlib",
  args: {
    tag: tool.schema.string().optional().describe("Filter by tag (exact match on individual tag)"),
    source: tool.schema.string().optional().describe("Filter by source (exact match)"),
    type: tool.schema.string().optional().describe("Entity type: terms (default), patterns, skills, rules, apologias, commands, protocols, abstractions, linguistics, persons, illustrations, or maxims"),
    query: tool.schema.string().optional().describe("Search across ID, title, tags, source, summary, principle, related"),
    status: tool.schema.string().optional().describe("Filter by status (active, draft) — patterns only"),
    state_profile: tool.schema.string().optional().describe("Filter by state_profile — skills only"),
    limit: tool.schema.number().optional().describe("Max results (default: 50)"),
    offset: tool.schema.number().optional().describe("Skip N results (default: 0)"),
  },
  async execute(args) {
    crashOnError()
    const db = initDB()

    if (args.type === "skills") {
      let sql = "SELECT id, title, body, skill, state_profile FROM skills"
      const conditions: string[] = []
      const params: Record<string, string|number> = {}

      if (args.state_profile) {
        conditions.push("state_profile = $state_profile")
        params.$state_profile = args.state_profile
      }

      if (args.query) {
        conditions.push("(id LIKE '%' || $query || '%' OR title LIKE '%' || $query || '%' OR body LIKE '%' || $query || '%' OR skill LIKE '%' || $query || '%')")
        params.$query = args.query
      }

      if (conditions.length > 0) {
        sql += " WHERE " + conditions.join(" AND ")
      }

      sql += " ORDER BY id"

      const limit = args.limit ?? 50
      const offset = args.offset ?? 0
      params.$limit = limit
      params.$offset = offset
      sql += " LIMIT $limit OFFSET $offset"

      const rows = queryAll(db, sql, params)
      db.close()

      if (rows.length === 0) return "No skills found."

      const lines = rows.map(r => `${r.id} ${r.title} [${r.state_profile}]`)
      lines.push(`\n${rows.length} skills.`)
      return lines.join("\n")
    }

    if (args.type === "rules") {
      let sql = "SELECT id, title, source, tags, related FROM rules"
      const conditions: string[] = []
      const params: Record<string, string|number> = {}
      if (args.tag) {
        conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
        params.$tag = args.tag
      }
      if (args.source) {
        conditions.push("source = $source")
        params.$source = args.source
      }
      if (args.query) {
        const likes = ["id", "title", "source", "tags"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
        conditions.push(`(${likes})`)
        params.$query = args.query
      }
      if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
      sql += " ORDER BY id"
      const limit = args.limit ?? 50
      const offset = args.offset ?? 0
      params.$limit = limit
      params.$offset = offset
      sql += " LIMIT $limit OFFSET $offset"
      const rows = queryAll(db, sql, params)
      db.close()
      if (rows.length === 0) return "No rules found."
      const lines = rows.map(r => {
        const source = r.source ? ` [${r.source}]` : ""
        const tags = r.tags ? ` (${r.tags})` : ""
        return `${r.id} ${r.title}${source}${tags}`
      })
      lines.push(`\n${rows.length} rules.`)
      return lines.join("\n")
    }

    if (args.type === "apologias") {
      let sql = "SELECT id, title, source, tags, related FROM apologias"
      const conditions: string[] = []
      const params: Record<string, string|number> = {}
      if (args.tag) {
        conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
        params.$tag = args.tag
      }
      if (args.source) {
        conditions.push("source = $source")
        params.$source = args.source
      }
      if (args.query) {
        const likes = ["id", "title", "source", "tags"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
        conditions.push(`(${likes})`)
        params.$query = args.query
      }
      if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
      sql += " ORDER BY id"
      const limit = args.limit ?? 50
      const offset = args.offset ?? 0
      params.$limit = limit
      params.$offset = offset
      sql += " LIMIT $limit OFFSET $offset"
      const rows = queryAll(db, sql, params)
      db.close()
      if (rows.length === 0) return "No apologias found."
      const lines = rows.map(r => {
        const source = r.source ? ` [${r.source}]` : ""
        const tags = r.tags ? ` (${r.tags})` : ""
        return `${r.id} ${r.title}${source}${tags}`
      })
      lines.push(`\n${rows.length} apologias.`)
      return lines.join("\n")
    }

    if (args.type === "commands") {
      let sql = "SELECT id, title, description, source, tags, related FROM commands"
      const conditions: string[] = []
      const params: Record<string, string|number> = {}
      if (args.tag) {
        conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
        params.$tag = args.tag
      }
      if (args.source) {
        conditions.push("source = $source")
        params.$source = args.source
      }
      if (args.query) {
        const likes = ["id", "title", "description", "source", "tags"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
        conditions.push(`(${likes})`)
        params.$query = args.query
      }
      if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
      sql += " ORDER BY id"
      const limit = args.limit ?? 50
      const offset = args.offset ?? 0
      params.$limit = limit
      params.$offset = offset
      sql += " LIMIT $limit OFFSET $offset"
      const rows = queryAll(db, sql, params)
      db.close()
      if (rows.length === 0) return "No commands found."
      const lines = rows.map(r => {
        const source = r.source ? ` [${r.source}]` : ""
        const tags = r.tags ? ` (${r.tags})` : ""
        const desc = r.description ? ` — ${r.description}` : ""
        return `${r.id} ${r.title}${source}${tags}${desc}`
      })
      lines.push(`\n${rows.length} commands.`)
      return lines.join("\n")
    }

    if (args.type === "protocols") {
      let sql = "SELECT id, title, source, tags, related, protocol, enforcement, status, priority FROM protocols"
      const conditions: string[] = []
      const params: Record<string, string|number> = {}
      if (args.tag) {
        conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
        params.$tag = args.tag
      }
      if (args.source) {
        conditions.push("source = $source")
        params.$source = args.source
      }
      if (args.status) {
        conditions.push("status = $status")
        params.$status = args.status
      }
      if (args.query) {
        const likes = ["id", "title", "source", "tags", "protocol"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
        conditions.push(`(${likes})`)
        params.$query = args.query
      }
      if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
      sql += " ORDER BY id"
      const limit = args.limit ?? 50
      const offset = args.offset ?? 0
      params.$limit = limit
      params.$offset = offset
      sql += " LIMIT $limit OFFSET $offset"
      const rows = queryAll(db, sql, params)
      db.close()
      if (rows.length === 0) return "No protocols found."
      const lines = rows.map(r => {
        const source = r.source ? ` [${r.source}]` : ""
        const tags = r.tags ? ` (${r.tags})` : ""
        return `${r.id} ${r.title}${source}${tags}`
      })
      lines.push(`\n${rows.length} protocols.`)
      return lines.join("\n")
    }

    if (args.type === "abstractions") {
      let sql = "SELECT id, title, source, tags, related FROM abstractions"
      const conditions: string[] = []
      const params: Record<string, string|number> = {}
      if (args.tag) {
        conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
        params.$tag = args.tag
      }
      if (args.source) {
        conditions.push("source = $source")
        params.$source = args.source
      }
      if (args.query) {
        const likes = ["id", "title", "source", "tags", "related"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
        conditions.push(`(${likes})`)
        params.$query = args.query
      }
      if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
      sql += " ORDER BY id"
      const limit = args.limit ?? 50
      const offset = args.offset ?? 0
      params.$limit = limit
      params.$offset = offset
      sql += " LIMIT $limit OFFSET $offset"
      const rows = queryAll(db, sql, params)
      db.close()
      if (rows.length === 0) return "No abstractions found."
      const lines = rows.map(r => {
        const source = r.source ? ` [${r.source}]` : ""
        const tags = r.tags ? ` (${r.tags})` : ""
        return `${r.id} ${r.title}${source}${tags}`
      })
      lines.push(`\n${rows.length} abstractions.`)
      return lines.join("\n")
    }

    if (args.type === "linguistics") {
      let sql = "SELECT id, title, source, tags, related FROM linguistics"
      const conditions: string[] = []
      const params: Record<string, string|number> = {}
      if (args.tag) {
        conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
        params.$tag = args.tag
      }
      if (args.source) {
        conditions.push("source = $source")
        params.$source = args.source
      }
      if (args.query) {
        const likes = ["id", "title", "source", "tags", "related"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
        conditions.push(`(${likes})`)
        params.$query = args.query
      }
      if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
      sql += " ORDER BY id"
      const limit = args.limit ?? 50
      const offset = args.offset ?? 0
      params.$limit = limit
      params.$offset = offset
      sql += " LIMIT $limit OFFSET $offset"
      const rows = queryAll(db, sql, params)
      db.close()
      if (rows.length === 0) return "No linguistics entries found."
      const lines = rows.map(r => {
        const source = r.source ? ` [${r.source}]` : ""
        const tags = r.tags ? ` (${r.tags})` : ""
        return `${r.id} ${r.title}${source}${tags}`
      })
      lines.push(`\n${rows.length} linguistics entries.`)
      return lines.join("\n")
    }

  if (args.type === "persons") {
    let sql = "SELECT id, title, source, tags FROM persons"
    const conditions: string[] = []
    const params: Record<string, string|number> = {}
    if (args.tag) {
      conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
      params.$tag = args.tag
    }
    if (args.source) {
      conditions.push("source = $source")
      params.$source = args.source
    }
    if (args.query) {
      const likes = ["id", "title", "source", "tags"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
      conditions.push(`(${likes})`)
      params.$query = args.query
    }
    if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
    sql += " ORDER BY id"
    const limit = args.limit ?? 50
    const offset = args.offset ?? 0
    params.$limit = limit
    params.$offset = offset
    sql += " LIMIT $limit OFFSET $offset"
    const rows = queryAll(db, sql, params)
    db.close()
    if (rows.length === 0) return "No persons found."
    const lines = rows.map(r => {
      const source = r.source ? ` [${r.source}]` : ""
      const tags = r.tags ? ` (${r.tags})` : ""
      return `${r.id} ${r.title}${source}${tags}`
    })
    lines.push(`\n${rows.length} persons.`)
    return lines.join("\n")
  }

  if (args.type === "illustrations") {
    let sql = "SELECT id, title, summary, source, tags FROM illustrations"
    const conditions: string[] = []
    const params: Record<string, string|number> = {}
    if (args.tag) {
      conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
      params.$tag = args.tag
    }
    if (args.source) {
      conditions.push("source = $source")
      params.$source = args.source
    }
    if (args.query) {
      const likes = ["id", "title", "source", "tags", "summary"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
      conditions.push(`(${likes})`)
      params.$query = args.query
    }
    if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
    sql += " ORDER BY id"
    const limit = args.limit ?? 50
    const offset = args.offset ?? 0
    params.$limit = limit
    params.$offset = offset
    sql += " LIMIT $limit OFFSET $offset"
    const rows = queryAll(db, sql, params)
    db.close()
    if (rows.length === 0) return "No illustrations found."
    const lines = rows.map(r => {
      const source = r.source ? ` [${r.source}]` : ""
      const tags = r.tags ? ` (${r.tags})` : ""
      const summary = r.summary ? `  ${String(r.summary).length > 80 ? String(r.summary).slice(0, 80) + "..." : r.summary}` : ""
      return `${r.id} ${r.title}${source}${tags}\n${summary}`
    })
    lines.push(`\n${rows.length} illustrations.`)
    return lines.join("\n")
  }

  if (args.type === "nexus") {
    let sql = "SELECT id, title, summary, source, tags, status FROM nexus"
    const conditions: string[] = []
    const params: Record<string, string|number> = {}
    if (args.tag) {
      conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
      params.$tag = args.tag
    }
    if (args.source) {
      conditions.push("source = $source")
      params.$source = args.source
    }
    if (args.status) {
      conditions.push("status = $status")
      params.$status = args.status
    }
    if (args.query) {
      const likes = ["id", "title", "source", "tags", "summary", "nexus", "composition"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
      conditions.push(`(${likes})`)
      params.$query = args.query
    }
    if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
    sql += " ORDER BY id"
    const limit = args.limit ?? 50
    const offset = args.offset ?? 0
    params.$limit = limit
    params.$offset = offset
    sql += " LIMIT $limit OFFSET $offset"
    const rows = queryAll(db, sql, params)
    db.close()
    if (rows.length === 0) return "No nexi found."
    const lines = rows.map(r => {
      const source = r.source ? ` [${r.source}]` : ""
      const tags = r.tags ? ` (${r.tags})` : ""
      const summary = r.summary ? `  ${String(r.summary).length > 80 ? String(r.summary).slice(0, 80) + "..." : r.summary}` : ""
      return `${r.id} ${r.title}${source}${tags}\n${summary}`
    })
    lines.push(`\n${rows.length} nexi.`)
    return lines.join("\n")
  }

  if (args.type === "maxims") {
    let sql = "SELECT id, title, summary, principle, source, tags, status FROM maxims"
    const conditions: string[] = []
    const params: Record<string, string|number> = {}
    if (args.tag) {
      conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
      params.$tag = args.tag
    }
    if (args.source) {
      conditions.push("source = $source")
      params.$source = args.source
    }
    if (args.status) {
      conditions.push("status = $status")
      params.$status = args.status
    }
    if (args.query) {
      const likes = ["id", "title", "source", "tags", "summary", "principle"].map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
      conditions.push(`(${likes})`)
      params.$query = args.query
    }
    if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ")
    sql += " ORDER BY id"
    const limit = args.limit ?? 50
    const offset = args.offset ?? 0
    params.$limit = limit
    params.$offset = offset
    sql += " LIMIT $limit OFFSET $offset"
    const rows = queryAll(db, sql, params)
    db.close()
    if (rows.length === 0) return "No maxims found."
    const lines = rows.map(r => {
      const source = r.source ? ` [${r.source}]` : ""
      const tags = r.tags ? ` (${r.tags})` : ""
      const summary = r.summary ? `  ${String(r.summary).length > 80 ? String(r.summary).slice(0, 80) + "..." : r.summary}` : ""
      const principle = r.principle ? `  ${String(r.principle).length > 80 ? String(r.principle).slice(0, 80) + "..." : r.principle}` : ""
      return `${r.id} ${r.title}${source}${tags}\n${summary}${principle ? "\n" + principle : ""}`
    })
    lines.push(`\n${rows.length} maxims.`)
    return lines.join("\n")
  }

    if (args.type === "nexus") { db.close(); return "Use --type nexus for nexus queries." }
    const entity = args.type === "patterns" ? "patterns" : "terms"

    let sql = `SELECT id, title, source, tags, created, modified`
    if (entity === "patterns") sql += ", summary, principle, status"
    if (entity === "terms") sql += ", related"
    sql += ` FROM ${entity}`
    const conditions: string[] = []
    const params: Record<string, string|number> = {}

    if (args.tag) {
      conditions.push("',' || tags || ',' LIKE '%,' || $tag || ',%'")
      params.$tag = args.tag
    }

    if (args.source) {
      conditions.push("source = $source")
      params.$source = args.source
    }

    if (args.status && entity === "patterns") {
      conditions.push("status = $status")
      params.$status = args.status
    }

    if (args.query) {
      const cols = ["id", "title", "source", "tags"]
      if (entity === "patterns") cols.push("summary", "principle")
      if (entity === "terms") cols.push("related")
      const likes = cols.map(c => `${c} LIKE '%' || $query || '%'`).join(" OR ")
      conditions.push(`(${likes})`)
      params.$query = args.query
    }

    if (conditions.length > 0) {
      sql += " WHERE " + conditions.join(" AND ")
    }

    sql += " ORDER BY id"

    const limit = args.limit ?? 50
    const offset = args.offset ?? 0
    params.$limit = limit
    params.$offset = offset
    sql += " LIMIT $limit OFFSET $offset"

    const rows = queryAll(db, sql, params)
    db.close()

    if (rows.length === 0) {
      return `No ${entity} found.`
    }

    const lines: string[] = []
    for (const row of rows) {
      const source = row.source ? ` [${row.source}]` : ""
      const tags = row.tags ? ` (${row.tags})` : ""
      lines.push(`${row.id} ${row.title}${source}${tags}`)
      if (entity === "patterns") {
        const snippet = row.summary ? (String(row.summary).length > 80 ? String(row.summary).slice(0, 80) + "..." : String(row.summary)) : ""
        if (snippet) lines.push(`  ${snippet}`)
      }
    }

    lines.push(`\n${rows.length} ${entity}.`)
    return lines.join("\n")
  },
})
