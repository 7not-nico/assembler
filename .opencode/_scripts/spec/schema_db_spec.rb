# ring: 1 (PURE)
# tests: _rb/schema_db.rb — SeedDB, QueryFields, LogRun

require "sqlite3"
require_relative "../_rb/loader"
require_relative "../_rb/schema_db"

failures = 0

check = ->(desc, actual, expected) {
  if actual == expected
    puts "  ✓ #{desc}"
  else
    puts "  ✗ #{desc}: expected #{expected.inspect}, got #{actual.inspect}"
    failures += 1
  end
}

puts "=== SeedDB ==="
db = SQLite3::Database.new(":memory:")
SeedDB.call(db)
types = db.execute("SELECT name FROM entity_types ORDER BY id")
check.call("seeds 19 entity types", types.size, 19)

maxim_fields = db.execute("SELECT name, required, field_type FROM fields WHERE entity_type_id = 'maxims' ORDER BY rowid")
check.call("maxims has 9 fields", maxim_fields.size, 9)

puts "=== QueryFields ==="
rows = QueryFields.call(db, "protocols")
check.call("protocols has 11 fields", rows.size, 11)
first = rows.first
check.call("protocols first field is id", first[0], "id")
check.call("protocols id is required", first[1], 1)
check.call("protocols id is string", first[2], "string")

puts "=== LogRun ==="
LogRun.call(db, "test-script", true, 0)
run = db.get_first_value("SELECT passed FROM schema_runs WHERE script = 'test-script'")
check.call("log run passed", run, 1)

LogRun.call(db, "test-script-2", false, 5)
run2 = db.get_first_value("SELECT violations FROM schema_runs WHERE script = 'test-script-2'")
check.call("log run violations", run2, 5)

puts failures == 0 ? "ok — all pass" : "FAIL — #{failures} failures"
exit(failures)
