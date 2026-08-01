# exports: ResolveSnippet, ResolveSnippets
# purity: DB-READ — queries voices.db
# depends-on: deps/loader, ./paths

require_relative "loader"
require_relative "paths"

ResolveSnippet = ->(id) {
  db = SQLite3::Database.new(DB_PATH.to_s)
  row = db.get_first_row("SELECT filepath, text, subject FROM snippets WHERE id = ?", [id])
  db.close
  next nil unless row

  abs = OBJECTS_REVISED.join(row[0].sub("../", ""))
  next nil unless File.exist?(abs)

  { path: abs.to_s, text: row[1], subject: row[2] }
}

ResolveSnippets = ->(ids) {
  ids.filter_map { |id|
    r = ResolveSnippet.call(id)
    r ? { id: id, **r } : nil
  }
}
