# exports: SeedDB, QueryFields, LogRun
# ring: 0 (PURE)

require "sqlite3"

DB_PATH = File.join(__dir__, "..", "schema", "schemas.db")
SQL_DIR = File.join(__dir__, "..", "schema")

SeedDB = ->(db = nil) {
  db ||= SQLite3::Database.new(DB_PATH)
  db.execute("PRAGMA journal_mode = WAL")
  db.execute("PRAGMA foreign_keys = ON")
  db.execute("PRAGMA busy_timeout = 5000")

  tables = db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='entity_types'")
  needs_seed = tables.empty?
  if needs_seed
    ddl = Dir.glob(File.join(SQL_DIR, "ddl.sql"))
    seeds = Dir.glob(File.join(SQL_DIR, "[0-9]*.sql")).sort
    (ddl + seeds).each do |path|
      sql = File.read(path)
      sql.split(";").each { |stmt| db.execute(stmt.strip) unless stmt.strip.empty? }
    end
  end
  db
}

QueryFields = ->(db, type_id) {
  db.execute(
    "SELECT name, required, field_type, enum_values, pattern, min_length, minimum FROM fields WHERE entity_type_id = ? ORDER BY rowid",
    [type_id]
  )
}

LogRun = ->(db, script, passed, violations) {
  db.execute("INSERT INTO schema_runs (script, passed, violations) VALUES (?, ?, ?)",
    [script, passed ? 1 : 0, violations])
}
