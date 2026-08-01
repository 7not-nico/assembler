#!/usr/bin/env ruby
require 'sqlite3'

DB_PATH = File.join(__dir__, 'semantics.db')
db = SQLite3::Database.new(DB_PATH)
db.results_as_hash = true

# ── Subject: COMMANDS dispatch table ──────────────────────────

COMMANDS = {
  'roles' => {
    sql:     'SELECT id, language, role, title, status FROM roles ORDER BY language, role',
    format:  :table,
    headers: %w[ID Language Role Title Status]
  },

  'lang' => {
    sql:     ->(lang) { ['SELECT id, role, title, status FROM roles WHERE language = ? ORDER BY role', lang] },
    format:  :table,
    headers: %w[ID Role Title Status],
    arg:     { optional: true, default: 'Ruby' }
  },

  'sources' => {
    sql:     ->(role_id = nil) {
      if role_id
        ['SELECT section, url FROM sources WHERE role_id = ? ORDER BY section', role_id.upcase.tr('-', '.')]
      else
        'SELECT s.role_id AS role, s.section, s.url FROM sources s ORDER BY s.role_id, s.section'
      end
    },
    format:  :list
  },

  'precedes' => {
    sql:     ->(role_id = nil) {
      if role_id
        ['SELECT precedes_id AS precedes FROM precedes WHERE role_id = ?', role_id.upcase.tr('-', '.')]
      else
        'SELECT role_id, precedes_id FROM precedes ORDER BY role_id'
      end
    },
    format:  :list
  },

  'urls' => {
    sql:     ->(lang = nil) {
      if lang
        ['SELECT section, url, roles FROM reference_urls WHERE language = ? ORDER BY section', lang]
      else
        'SELECT language, section, url, roles FROM reference_urls ORDER BY language, section'
      end
    },
    format:  :list
  },

  'sql' => {
    sql:     ->(*fragments) { [fragments.join(' ')] },
    format:  :raw,
    arg:     { required: true, variadic: true }
  }
}.freeze

# ── Formatters: three output shapes ────────────────────────────

HEADER_UNDERLINE = ->(widths) { widths.map { |w| '-' * w }.join('  ') }

def fmt_table(rows, headers)
  return puts '(no rows)' if rows.empty?
  widths = headers.map.with_index { |h, i| [h.size, rows.map { |r| r.values[i].to_s.size }.max].max }
  sep = '  '
  fmt = widths.map { |w| "%-#{w}s" }.join(sep)
  puts fmt % headers
  puts HEADER_UNDERLINE.call(widths)
  rows.each { |r| puts fmt % r.values }
end

def fmt_list(rows)
  return puts '(no rows)' if rows.empty?
  rows.each do |r|
    r.each { |k, v| puts "  #{k}: #{v}" }
    puts
  end
end

def fmt_raw(rows)
  return puts '(no rows)' if rows.empty?
  rows.each { |r| puts r.values.join("\t") }
end

FORMATTERS = { table: :fmt_table, list: :fmt_list, raw: :fmt_raw }.freeze

# ── Action: dispatch pipeline ──────────────────────────────────

cmd, *args = ARGV
entry = COMMANDS[cmd]

unless entry
  puts "Usage: ruby schema/query.rb <command> [args]"
  puts
  puts "Commands:"
  COMMANDS.each_key { |k| puts "  #{k}" }
  exit
end

# Resolve arguments
arg_spec = entry[:arg] || {}
if arg_spec[:required] && args.empty?
  puts "Error: #{cmd} requires an argument"
  exit 1
end

resolved =
  if arg_spec[:variadic]
    [args]
  elsif args.empty? && arg_spec[:optional]
    [arg_spec[:default]]
  elsif args.empty?
    []
  else
    args
  end

# Execute SQL
sql_def = entry[:sql]
rows =
  if sql_def.is_a?(Proc)
    db.execute(*sql_def.call(*resolved))
  else
    db.execute(sql_def)
  end

# Format output
formatter = FORMATTERS.fetch(entry[:format])
if entry[:format] == :table
  send(formatter, rows, entry[:headers])
else
  send(formatter, rows)
end
