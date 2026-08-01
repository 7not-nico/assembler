require 'sqlite3'
require 'digest'
require 'yaml'
require 'pathname'

KNOWLEDGE_DIR = File.join(__dir__, '..', 'ruby')
PRACTICE_DIR  = File.join(__dir__, '..', 'practice')
DB_PATH       = File.join(__dir__, 'knowledge.db')

DB = SQLite3::Database.new(DB_PATH)
DB.execute_batch(File.read(File.join(__dir__, 'schema.sql')))

# concept categories inferred from filename patterns
CATEGORY_MAP = {
  'proc'              => 'class',
  'lambda'            => 'semantics',
  'closure'           => 'semantics',
  'composition'       => 'functional',
  'curry'             => 'functional',
  'anonymous-params'  => 'syntax',
  'to-proc'           => 'protocol',
  'string'            => 'class',
  'string-slice'      => 'access',
  'string-substitution' => 'modify',
  'string-query'      => 'query',
  'string-case'       => 'modify',
  'string-modify'     => 'modify',
  'string-encoding'   => 'encoding',
  'string-convert'    => 'convert',
  'symbol'            => 'class',
  'array'             => 'class',
  'array-access'      => 'access',
  'array-add'         => 'modify',
  'array-remove'      => 'modify',
  'array-query'       => 'query',
  'array-transform'   => 'transform',
  'array-set'         => 'set'
}

CONCERN_MAP = {
  'proc'              => 'Creation, invocation, key methods, arity',
  'lambda'            => 'Lambda vs non-lambda — 5 semantic differences',
  'closure'           => 'Closures, scope capture, binding, orphaned',
  'composition'       => 'Function composition — >>/<<, pipelines',
  'curry'             => 'Currying, partial application',
  'anonymous-params'  => 'it, _1.._9 implicit block parameters',
  'to-proc'           => '& conversion protocol — Symbol, Method, Hash, custom',
  'string'            => 'Class overview, creation, bang convention',
  'string-slice'      => '[]/slice — index, range, regexp, substring forms',
  'string-substitution' => 'sub/gsub — patterns, back-references, block form',
  'string-query'      => 'Querying: length, include?, match, encoding',
  'string-case'       => 'Casing: upcase, downcase, capitalize, swapcase',
  'string-modify'     => 'Mutation: insert, clear, delete, replace, tr',
  'string-encoding'   => 'Encoding: valid?, encode, force_encoding, scrub',
  'string-convert'    => 'Conversion: to_i, to_f, to_sym, split, chars',
  'symbol'            => 'Symbol identity, querying, conversion, to_proc',
  'array'             => 'Creation, indexing, class overview',
  'array-access'      => 'Fetching: [], slice, fetch, take, drop, assoc',
  'array-add'         => 'Adding: push, <<, unshift, insert, concat, fill',
  'array-remove'      => 'Removing: pop, shift, delete, compact, uniq',
  'array-query'       => 'Querying: length, include?, any?, all?, empty?',
  'array-transform'   => 'Transforming: map, select, sort, reverse, flatten',
  'array-set'         => 'Set ops: |, &, -, union, intersection, difference'
}

def extract_title(file)
  line = File.open(file, &:readline) rescue ''
  m = line.match(/^# (.+)$/) || line.match(/^## (.+)$/)
  m ? m[1].strip : File.basename(file, '.md').tr('-', ' ').capitalize
end

def checksum(file)
  Digest::SHA256.hexdigest(File.read(file))
end

def subheadings(file)
  File.read(file).scan(/^## (.+)$/).flatten.map(&:strip)
rescue
  []
end

def run_practice(script)
  out = `ruby #{script} 2>&1`
  passed = out.scan(/PASS:/).size
  failed = out.scan(/FAIL:/).size
  { passed: passed, failed: failed, output: out }
rescue => e
  { passed: 0, failed: -1, output: e.message }
end

added = 0
updated = 0
skipped = 0

Dir[File.join(KNOWLEDGE_DIR, '*.md')].each do |file|
  slug = File.basename(file, '.md')
  domain = 'ruby'
  title = extract_title(file)
  concern = CONCERN_MAP[slug] || title
  category = CATEGORY_MAP[slug] || 'other'
  rel_path = Pathname.new(file).relative_path_from(Pathname.new(File.join(__dir__, '..'))).to_s
  cs = checksum(file)

  existing = DB.get_first_row("SELECT id, checksum FROM files WHERE domain=? AND slug=?", [domain, slug])

  if existing
    if existing[1] == cs
      skipped += 1
    else
      DB.execute("UPDATE files SET title=?, concern=?, path=?, checksum=?, modified_at=datetime('now') WHERE id=?",
                 [title, concern, rel_path, cs, existing[0]])
      updated += 1
    end
    file_id = existing[0]
  else
    DB.execute("INSERT INTO files (domain, slug, title, concern, path, checksum) VALUES (?,?,?,?,?,?)",
               [domain, slug, title, concern, rel_path, cs])
    file_id = DB.last_insert_row_id
    added += 1
  end

  DB.execute("DELETE FROM concepts WHERE file_id=?", [file_id])
  subheadings(file).each do |h|
    DB.execute("INSERT INTO concepts (file_id, concept, category) VALUES (?,?,?)", [file_id, h, category])
  end
end

# sync practice results
Dir[File.join(PRACTICE_DIR, 'test-*.rb')].each do |script|
  slug = File.basename(script, '.rb').sub(/^test-/, '')
  row = DB.get_first_row("SELECT id FROM files WHERE slug=?", [slug])
  next unless row
  file_id = row[0]
  result = run_practice(script)
  rel = Pathname.new(script).relative_path_from(Pathname.new(File.join(__dir__, '..'))).to_s
  existing_p = DB.get_first_row("SELECT id FROM practices WHERE file_id=?", [file_id])
  if existing_p
    DB.execute("UPDATE practices SET path=?, passed=?, failed=?, last_run=datetime('now') WHERE id=?",
               [rel, result[:passed], result[:failed], existing_p[0]])
  else
    DB.execute("INSERT INTO practices (file_id, path, passed, failed, last_run) VALUES (?,?,?,?,datetime('now'))",
               [file_id, rel, result[:passed], result[:failed]])
  end
end

puts "Sync complete: #{added} added, #{updated} updated, #{skipped} skipped"
